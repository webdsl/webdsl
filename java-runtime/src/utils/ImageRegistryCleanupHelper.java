package utils;

import javax.imageio.spi.IIORegistry;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;

public class ImageRegistryCleanupHelper {

    public static void deregisterWebappProviders() {
        try {
            // Track the specific classloader that is dying
            ClassLoader webAppClassLoader = Thread.currentThread().getContextClassLoader();
            if (webAppClassLoader == null) {
                webAppClassLoader = ImageRegistryCleanupHelper.class.getClassLoader();
            }

            IIORegistry registry = IIORegistry.getDefaultInstance();
            Iterator<Class<?>> categories = registry.getCategories();

            org.webdsl.logging.Logger.info("cleanup: unregistering ImageIO spi registry references");

            // Iterate through all SPI image plugin categories (Readers, Writers, etc.)
            while (categories.hasNext()) {
                Class<?> category = categories.next();
                Iterator<?> providers = registry.getServiceProviders(category, false);
                List<Object> providersToDeregister = new ArrayList<>();
                org.webdsl.logging.Logger.info("cleanup: checking category: " + category.getName());

                while (providers.hasNext()) {
                    Object provider = providers.next();
                    // Identify if the plugin provider was instantiated by the dying web application
                    if (provider.getClass().getClassLoader() == webAppClassLoader) {
                        providersToDeregister.add(provider);
                    }
                }

                // Unbind the leaked image providers from the server-wide registry
                for (Object provider : providersToDeregister) {
                    org.webdsl.logging.Logger.info("cleanup: unregistering ImageIO spi registry reference: " + provider.getClass().getName());
                    registry.deregisterServiceProvider(provider);
                }
            }
            
            // Force a rescan to clean up global internal soft/weak cache pools
            javax.imageio.ImageIO.scanForPlugins();
            
            // Proactively invoke GC to prompt the OS to release the unmapped .dylib file descriptor locks
            System.gc();
            
        } catch (Exception ex) {
            // Fall back to system error logging if the application logger framework is already closed
            org.webdsl.logging.Logger.error("Warning: ImageRegistryCleanupHelper encountered an error: " + ex.getMessage());
        }
    }
}