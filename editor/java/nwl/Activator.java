package nwl;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.imp.preferences.PreferencesService;
import org.eclipse.imp.runtime.PluginBase;
import org.osgi.framework.BundleContext;

public class Activator extends PluginBase 
{ 
  public static final String kPluginID = "Nwl";

  public static final String kLanguageName = "Nwl";

  protected static Activator sPlugin;

  public static Activator getInstance()
  { 
    if(sPlugin == null)
      return new Activator();
    return sPlugin;
  }

  public Activator () 
  { 
    super();
    sPlugin = this;
  }

  @Override public void start(BundleContext context) throws Exception
  { 
    super.start(context);
  }

  @Override public String getID()
  { 
    return kPluginID;
  }

  protected static PreferencesService preferencesService = null;

  public static PreferencesService getPreferencesService()
  { 
    if(preferencesService == null)
    { 
      preferencesService = new PreferencesService(ResourcesPlugin.getWorkspace().getRoot().getProject());
      preferencesService.setLanguageName(kLanguageName);
    }
    return preferencesService;
  }
}