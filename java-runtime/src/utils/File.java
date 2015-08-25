package utils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity public class File
{ 
  public File () 
  { }

  @Id @GeneratedValue private Long id;

  public Long getId()
  { 
    return id;
  }

  public void setId(Long id)
  { 
    this.id = id;
  }

  public boolean equals(Object o)
  { 
    return o != null && org.webdsl.tools.Utils.isInstance(o, File.class) && org.webdsl.tools.Utils.equal(((File)o).getId(), getId());
  }

  public int hashCode()
  { 
    if(getId() == null)
      return super.hashCode();
    else
      return getId().hashCode();
  }
  
  private java.sql.Blob	content	= null;

  public java.sql.Blob getContent(){
    return content;
  }

  private void setContent(java.sql.Blob content ){
    this.content = content;
    try {
		this.sizeInBytes = content.length();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
  }

  public java.io.InputStream getContentStream()
            throws java.sql.SQLException
  {
    if (getContent() == null)
      return null;
    return getContent().getBinaryStream();
  }

  public void setContentStream( java.io.InputStream sourceStream )
            throws java.io.IOException
  {
    setContent( org.hibernate.Hibernate.createBlob( sourceStream ) );
  }
  
  public String getContentAsString(){
    try {
        InputStream inputStream = getContent().getBinaryStream();
        int expected = inputStream.available();
        byte[] contents = new byte[expected];
        int length = inputStream.read(contents);
        if(length != expected)
            return "";
        return new String(contents);
    } catch (SQLException e) {
        org.webdsl.logging.Logger.error("EXCEPTION",e);
        return "";
    } catch (IOException e) {
        org.webdsl.logging.Logger.error("EXCEPTION",e);
        return "";
    }
  }

  @org.hibernate.annotations.AccessType(value = "field") protected String fileName = "";

  public String getFileName()
  { 
    return fileName;
  }

  public void setFileName(String newitem)
  { 
    fileName = newitem;
  }

  @org.hibernate.annotations.AccessType(value = "field") protected long sizeInBytes = 0;

  public long getSizeInBytes()
  { 
    return sizeInBytes;
  }

  public void setSizeInBytes(long newitem)
  { 
      sizeInBytes = newitem;
  }
    
  @org.hibernate.annotations.AccessType(value = "field") protected String contentType = "";

  public String getContentType() {
    return contentType;
  }
    
  public void setContentType(String contentType) {
    this.contentType = contentType;
  }
  
  public utils.File makeClone() {
      utils.File newF = new utils.File();
      newF.setContent(content);
      newF.setFileName(fileName);
      newF.setContentType(contentType);
      return newF;
  }
  public File delete(){
      HibernateUtil.getCurrentSession().delete(this);
      return this;
    }
  
  /* 
   * http://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types
   * regex pattern:
   * (^\S+)\s+(\w+).*
   * replace with:
   * mimeToExt.put("\1","\2");
   */
  private static Map<String, String> mimeToExt = new HashMap<String, String>();
  
  public static String mimeTypeToExt(String mimeType){
	  return mimeToExt.get(mimeType);
  }
  static{
  	mimeToExt.put("application/andrew-inset","ez");
  	mimeToExt.put("application/applixware","aw");
  	mimeToExt.put("application/atom+xml","atom");
  	mimeToExt.put("application/atomcat+xml","atomcat");
  	mimeToExt.put("application/atomsvc+xml","atomsvc");
  	mimeToExt.put("application/ccxml+xml","ccxml");
  	mimeToExt.put("application/cdmi-capability","cdmia");
  	mimeToExt.put("application/cdmi-container","cdmic");
  	mimeToExt.put("application/cdmi-domain","cdmid");
  	mimeToExt.put("application/cdmi-object","cdmio");
  	mimeToExt.put("application/cdmi-queue","cdmiq");
  	mimeToExt.put("application/cu-seeme","cu");
  	mimeToExt.put("application/davmount+xml","davmount");
  	mimeToExt.put("application/docbook+xml","dbk");
  	mimeToExt.put("application/dssc+der","dssc");
  	mimeToExt.put("application/dssc+xml","xdssc");
  	mimeToExt.put("application/ecmascript","ecma");
  	mimeToExt.put("application/emma+xml","emma");
  	mimeToExt.put("application/epub+zip","epub");
  	mimeToExt.put("application/exi","exi");
  	mimeToExt.put("application/font-tdpfr","pfr");
  	mimeToExt.put("application/gml+xml","gml");
  	mimeToExt.put("application/gpx+xml","gpx");
  	mimeToExt.put("application/gxf","gxf");
  	mimeToExt.put("application/hyperstudio","stk");
  	mimeToExt.put("application/inkml+xml","ink");
  	mimeToExt.put("application/ipfix","ipfix");
  	mimeToExt.put("application/java-archive","jar");
  	mimeToExt.put("application/java-serialized-object","ser");
  	mimeToExt.put("application/java-vm","class");
  	mimeToExt.put("application/javascript","js");
  	mimeToExt.put("application/json","json");
  	mimeToExt.put("application/jsonml+json","jsonml");
  	mimeToExt.put("application/lost+xml","lostxml");
  	mimeToExt.put("application/mac-binhex40","hqx");
  	mimeToExt.put("application/mac-compactpro","cpt");
  	mimeToExt.put("application/mads+xml","mads");
  	mimeToExt.put("application/marc","mrc");
  	mimeToExt.put("application/marcxml+xml","mrcx");
  	mimeToExt.put("application/mathematica","ma");
  	mimeToExt.put("application/mathml+xml","mathml");
  	mimeToExt.put("application/mbox","mbox");
  	mimeToExt.put("application/mediaservercontrol+xml","mscml");
  	mimeToExt.put("application/metalink+xml","metalink");
  	mimeToExt.put("application/metalink4+xml","meta4");
  	mimeToExt.put("application/mets+xml","mets");
  	mimeToExt.put("application/mods+xml","mods");
  	mimeToExt.put("application/mp21","m21");
  	mimeToExt.put("application/mp4","mp4s");
  	mimeToExt.put("application/msword","doc");
  	mimeToExt.put("application/mxf","mxf");
  	mimeToExt.put("application/octet-stream","bin");
  	mimeToExt.put("application/oda","oda");
  	mimeToExt.put("application/oebps-package+xml","opf");
  	mimeToExt.put("application/ogg","ogx");
  	mimeToExt.put("application/omdoc+xml","omdoc");
  	mimeToExt.put("application/onenote","onetoc");
  	mimeToExt.put("application/oxps","oxps");
  	mimeToExt.put("application/patch-ops-error+xml","xer");
  	mimeToExt.put("application/pdf","pdf");
  	mimeToExt.put("application/pgp-encrypted","pgp");
  	mimeToExt.put("application/pgp-signature","asc");
  	mimeToExt.put("application/pics-rules","prf");
  	mimeToExt.put("application/pkcs10","p10");
  	mimeToExt.put("application/pkcs7-mime","p7m");
  	mimeToExt.put("application/pkcs7-signature","p7s");
  	mimeToExt.put("application/pkcs8","p8");
  	mimeToExt.put("application/pkix-attr-cert","ac");
  	mimeToExt.put("application/pkix-cert","cer");
  	mimeToExt.put("application/pkix-crl","crl");
  	mimeToExt.put("application/pkix-pkipath","pkipath");
  	mimeToExt.put("application/pkixcmp","pki");
  	mimeToExt.put("application/pls+xml","pls");
  	mimeToExt.put("application/postscript","ai");
  	mimeToExt.put("application/prs.cww","cww");
  	mimeToExt.put("application/pskc+xml","pskcxml");
  	mimeToExt.put("application/rdf+xml","rdf");
  	mimeToExt.put("application/reginfo+xml","rif");
  	mimeToExt.put("application/relax-ng-compact-syntax","rnc");
  	mimeToExt.put("application/resource-lists+xml","rl");
  	mimeToExt.put("application/resource-lists-diff+xml","rld");
  	mimeToExt.put("application/rls-services+xml","rs");
  	mimeToExt.put("application/rpki-ghostbusters","gbr");
  	mimeToExt.put("application/rpki-manifest","mft");
  	mimeToExt.put("application/rpki-roa","roa");
  	mimeToExt.put("application/rsd+xml","rsd");
  	mimeToExt.put("application/rss+xml","rss");
  	mimeToExt.put("application/rtf","rtf");
  	mimeToExt.put("application/sbml+xml","sbml");
  	mimeToExt.put("application/scvp-cv-request","scq");
  	mimeToExt.put("application/scvp-cv-response","scs");
  	mimeToExt.put("application/scvp-vp-request","spq");
  	mimeToExt.put("application/scvp-vp-response","spp");
  	mimeToExt.put("application/sdp","sdp");
  	mimeToExt.put("application/set-payment-initiation","setpay");
  	mimeToExt.put("application/set-registration-initiation","setreg");
  	mimeToExt.put("application/shf+xml","shf");
  	mimeToExt.put("application/smil+xml","smi");
  	mimeToExt.put("application/sparql-query","rq");
  	mimeToExt.put("application/sparql-results+xml","srx");
  	mimeToExt.put("application/srgs","gram");
  	mimeToExt.put("application/srgs+xml","grxml");
  	mimeToExt.put("application/sru+xml","sru");
  	mimeToExt.put("application/ssdl+xml","ssdl");
  	mimeToExt.put("application/ssml+xml","ssml");
  	mimeToExt.put("application/tei+xml","tei");
  	mimeToExt.put("application/thraud+xml","tfi");
  	mimeToExt.put("application/timestamped-data","tsd");
  	mimeToExt.put("application/vnd.3gpp.pic-bw-large","plb");
  	mimeToExt.put("application/vnd.3gpp.pic-bw-small","psb");
  	mimeToExt.put("application/vnd.3gpp.pic-bw-var","pvb");
  	mimeToExt.put("application/vnd.3gpp2.tcap","tcap");
  	mimeToExt.put("application/vnd.3m.post-it-notes","pwn");
  	mimeToExt.put("application/vnd.accpac.simply.aso","aso");
  	mimeToExt.put("application/vnd.accpac.simply.imp","imp");
  	mimeToExt.put("application/vnd.acucobol","acu");
  	mimeToExt.put("application/vnd.acucorp","atc");
  	mimeToExt.put("application/vnd.adobe.air-application-installer-package+zip","air");
  	mimeToExt.put("application/vnd.adobe.formscentral.fcdt","fcdt");
  	mimeToExt.put("application/vnd.adobe.fxp","fxp");
  	mimeToExt.put("application/vnd.adobe.xdp+xml","xdp");
  	mimeToExt.put("application/vnd.adobe.xfdf","xfdf");
  	mimeToExt.put("application/vnd.ahead.space","ahead");
  	mimeToExt.put("application/vnd.airzip.filesecure.azf","azf");
  	mimeToExt.put("application/vnd.airzip.filesecure.azs","azs");
  	mimeToExt.put("application/vnd.amazon.ebook","azw");
  	mimeToExt.put("application/vnd.americandynamics.acc","acc");
  	mimeToExt.put("application/vnd.amiga.ami","ami");
  	mimeToExt.put("application/vnd.android.package-archive","apk");
  	mimeToExt.put("application/vnd.anser-web-certificate-issue-initiation","cii");
  	mimeToExt.put("application/vnd.anser-web-funds-transfer-initiation","fti");
  	mimeToExt.put("application/vnd.antix.game-component","atx");
  	mimeToExt.put("application/vnd.apple.installer+xml","mpkg");
  	mimeToExt.put("application/vnd.apple.mpegurl","m3u8");
  	mimeToExt.put("application/vnd.aristanetworks.swi","swi");
  	mimeToExt.put("application/vnd.astraea-software.iota","iota");
  	mimeToExt.put("application/vnd.audiograph","aep");
  	mimeToExt.put("application/vnd.blueice.multipass","mpm");
  	mimeToExt.put("application/vnd.bmi","bmi");
  	mimeToExt.put("application/vnd.businessobjects","rep");
  	mimeToExt.put("application/vnd.chemdraw+xml","cdxml");
  	mimeToExt.put("application/vnd.chipnuts.karaoke-mmd","mmd");
  	mimeToExt.put("application/vnd.cinderella","cdy");
  	mimeToExt.put("application/vnd.claymore","cla");
  	mimeToExt.put("application/vnd.cloanto.rp9","rp9");
  	mimeToExt.put("application/vnd.clonk.c4group","c4g");
  	mimeToExt.put("application/vnd.cluetrust.cartomobile-config","c11amc");
  	mimeToExt.put("application/vnd.cluetrust.cartomobile-config-pkg","c11amz");
  	mimeToExt.put("application/vnd.commonspace","csp");
  	mimeToExt.put("application/vnd.contact.cmsg","cdbcmsg");
  	mimeToExt.put("application/vnd.cosmocaller","cmc");
  	mimeToExt.put("application/vnd.crick.clicker","clkx");
  	mimeToExt.put("application/vnd.crick.clicker.keyboard","clkk");
  	mimeToExt.put("application/vnd.crick.clicker.palette","clkp");
  	mimeToExt.put("application/vnd.crick.clicker.template","clkt");
  	mimeToExt.put("application/vnd.crick.clicker.wordbank","clkw");
  	mimeToExt.put("application/vnd.criticaltools.wbs+xml","wbs");
  	mimeToExt.put("application/vnd.ctc-posml","pml");
  	mimeToExt.put("application/vnd.cups-ppd","ppd");
  	mimeToExt.put("application/vnd.curl.car","car");
  	mimeToExt.put("application/vnd.curl.pcurl","pcurl");
  	mimeToExt.put("application/vnd.dart","dart");
  	mimeToExt.put("application/vnd.data-vision.rdz","rdz");
  	mimeToExt.put("application/vnd.dece.data","uvf");
  	mimeToExt.put("application/vnd.dece.ttml+xml","uvt");
  	mimeToExt.put("application/vnd.dece.unspecified","uvx");
  	mimeToExt.put("application/vnd.dece.zip","uvz");
  	mimeToExt.put("application/vnd.denovo.fcselayout-link","fe_launch");
  	mimeToExt.put("application/vnd.dna","dna");
  	mimeToExt.put("application/vnd.dolby.mlp","mlp");
  	mimeToExt.put("application/vnd.dpgraph","dpg");
  	mimeToExt.put("application/vnd.dreamfactory","dfac");
  	mimeToExt.put("application/vnd.ds-keypoint","kpxx");
  	mimeToExt.put("application/vnd.dvb.ait","ait");
  	mimeToExt.put("application/vnd.dvb.service","svc");
  	mimeToExt.put("application/vnd.dynageo","geo");
  	mimeToExt.put("application/vnd.ecowin.chart","mag");
  	mimeToExt.put("application/vnd.enliven","nml");
  	mimeToExt.put("application/vnd.epson.esf","esf");
  	mimeToExt.put("application/vnd.epson.msf","msf");
  	mimeToExt.put("application/vnd.epson.quickanime","qam");
  	mimeToExt.put("application/vnd.epson.salt","slt");
  	mimeToExt.put("application/vnd.epson.ssf","ssf");
  	mimeToExt.put("application/vnd.eszigno3+xml","es3");
  	mimeToExt.put("application/vnd.ezpix-album","ez2");
  	mimeToExt.put("application/vnd.ezpix-package","ez3");
  	mimeToExt.put("application/vnd.fdf","fdf");
  	mimeToExt.put("application/vnd.fdsn.mseed","mseed");
  	mimeToExt.put("application/vnd.fdsn.seed","seed");
  	mimeToExt.put("application/vnd.flographit","gph");
  	mimeToExt.put("application/vnd.fluxtime.clip","ftc");
  	mimeToExt.put("application/vnd.framemaker","fm");
  	mimeToExt.put("application/vnd.frogans.fnc","fnc");
  	mimeToExt.put("application/vnd.frogans.ltf","ltf");
  	mimeToExt.put("application/vnd.fsc.weblaunch","fsc");
  	mimeToExt.put("application/vnd.fujitsu.oasys","oas");
  	mimeToExt.put("application/vnd.fujitsu.oasys2","oa2");
  	mimeToExt.put("application/vnd.fujitsu.oasys3","oa3");
  	mimeToExt.put("application/vnd.fujitsu.oasysgp","fg5");
  	mimeToExt.put("application/vnd.fujitsu.oasysprs","bh2");
  	mimeToExt.put("application/vnd.fujixerox.ddd","ddd");
  	mimeToExt.put("application/vnd.fujixerox.docuworks","xdw");
  	mimeToExt.put("application/vnd.fujixerox.docuworks.binder","xbd");
  	mimeToExt.put("application/vnd.fuzzysheet","fzs");
  	mimeToExt.put("application/vnd.genomatix.tuxedo","txd");
  	mimeToExt.put("application/vnd.geogebra.file","ggb");
  	mimeToExt.put("application/vnd.geogebra.tool","ggt");
  	mimeToExt.put("application/vnd.geometry-explorer","gex");
  	mimeToExt.put("application/vnd.geonext","gxt");
  	mimeToExt.put("application/vnd.geoplan","g2w");
  	mimeToExt.put("application/vnd.geospace","g3w");
  	mimeToExt.put("application/vnd.gmx","gmx");
  	mimeToExt.put("application/vnd.google-earth.kml+xml","kml");
  	mimeToExt.put("application/vnd.google-earth.kmz","kmz");
  	mimeToExt.put("application/vnd.grafeq","gqf");
  	mimeToExt.put("application/vnd.groove-account","gac");
  	mimeToExt.put("application/vnd.groove-help","ghf");
  	mimeToExt.put("application/vnd.groove-identity-message","gim");
  	mimeToExt.put("application/vnd.groove-injector","grv");
  	mimeToExt.put("application/vnd.groove-tool-message","gtm");
  	mimeToExt.put("application/vnd.groove-tool-template","tpl");
  	mimeToExt.put("application/vnd.groove-vcard","vcg");
  	mimeToExt.put("application/vnd.hal+xml","hal");
  	mimeToExt.put("application/vnd.handheld-entertainment+xml","zmm");
  	mimeToExt.put("application/vnd.hbci","hbci");
  	mimeToExt.put("application/vnd.hhe.lesson-player","les");
  	mimeToExt.put("application/vnd.hp-hpgl","hpgl");
  	mimeToExt.put("application/vnd.hp-hpid","hpid");
  	mimeToExt.put("application/vnd.hp-hps","hps");
  	mimeToExt.put("application/vnd.hp-jlyt","jlt");
  	mimeToExt.put("application/vnd.hp-pcl","pcl");
  	mimeToExt.put("application/vnd.hp-pclxl","pclxl");
  	mimeToExt.put("application/vnd.hydrostatix.sof-data","sfd");
  	mimeToExt.put("application/vnd.ibm.minipay","mpy");
  	mimeToExt.put("application/vnd.ibm.modcap","afp");
  	mimeToExt.put("application/vnd.ibm.rights-management","irm");
  	mimeToExt.put("application/vnd.ibm.secure-container","sc");
  	mimeToExt.put("application/vnd.iccprofile","icc");
  	mimeToExt.put("application/vnd.igloader","igl");
  	mimeToExt.put("application/vnd.immervision-ivp","ivp");
  	mimeToExt.put("application/vnd.immervision-ivu","ivu");
  	mimeToExt.put("application/vnd.insors.igm","igm");
  	mimeToExt.put("application/vnd.intercon.formnet","xpw");
  	mimeToExt.put("application/vnd.intergeo","i2g");
  	mimeToExt.put("application/vnd.intu.qbo","qbo");
  	mimeToExt.put("application/vnd.intu.qfx","qfx");
  	mimeToExt.put("application/vnd.ipunplugged.rcprofile","rcprofile");
  	mimeToExt.put("application/vnd.irepository.package+xml","irp");
  	mimeToExt.put("application/vnd.is-xpr","xpr");
  	mimeToExt.put("application/vnd.isac.fcs","fcs");
  	mimeToExt.put("application/vnd.jam","jam");
  	mimeToExt.put("application/vnd.jcp.javame.midlet-rms","rms");
  	mimeToExt.put("application/vnd.jisp","jisp");
  	mimeToExt.put("application/vnd.joost.joda-archive","joda");
  	mimeToExt.put("application/vnd.kahootz","ktz");
  	mimeToExt.put("application/vnd.kde.karbon","karbon");
  	mimeToExt.put("application/vnd.kde.kchart","chrt");
  	mimeToExt.put("application/vnd.kde.kformula","kfo");
  	mimeToExt.put("application/vnd.kde.kivio","flw");
  	mimeToExt.put("application/vnd.kde.kontour","kon");
  	mimeToExt.put("application/vnd.kde.kpresenter","kpr");
  	mimeToExt.put("application/vnd.kde.kspread","ksp");
  	mimeToExt.put("application/vnd.kde.kword","kwd");
  	mimeToExt.put("application/vnd.kenameaapp","htke");
  	mimeToExt.put("application/vnd.kidspiration","kia");
  	mimeToExt.put("application/vnd.kinar","kne");
  	mimeToExt.put("application/vnd.koan","skp");
  	mimeToExt.put("application/vnd.kodak-descriptor","sse");
  	mimeToExt.put("application/vnd.las.las+xml","lasxml");
  	mimeToExt.put("application/vnd.llamagraphics.life-balance.desktop","lbd");
  	mimeToExt.put("application/vnd.llamagraphics.life-balance.exchange+xml","lbe");
  	mimeToExt.put("application/vnd.lotus-1-2-3","123");
  	mimeToExt.put("application/vnd.lotus-approach","apr");
  	mimeToExt.put("application/vnd.lotus-freelance","pre");
  	mimeToExt.put("application/vnd.lotus-notes","nsf");
  	mimeToExt.put("application/vnd.lotus-organizer","org");
  	mimeToExt.put("application/vnd.lotus-screencam","scm");
  	mimeToExt.put("application/vnd.lotus-wordpro","lwp");
  	mimeToExt.put("application/vnd.macports.portpkg","portpkg");
  	mimeToExt.put("application/vnd.mcd","mcd");
  	mimeToExt.put("application/vnd.medcalcdata","mc1");
  	mimeToExt.put("application/vnd.mediastation.cdkey","cdkey");
  	mimeToExt.put("application/vnd.mfer","mwf");
  	mimeToExt.put("application/vnd.mfmp","mfm");
  	mimeToExt.put("application/vnd.micrografx.flo","flo");
  	mimeToExt.put("application/vnd.micrografx.igx","igx");
  	mimeToExt.put("application/vnd.mif","mif");
  	mimeToExt.put("application/vnd.mobius.daf","daf");
  	mimeToExt.put("application/vnd.mobius.dis","dis");
  	mimeToExt.put("application/vnd.mobius.mbk","mbk");
  	mimeToExt.put("application/vnd.mobius.mqy","mqy");
  	mimeToExt.put("application/vnd.mobius.msl","msl");
  	mimeToExt.put("application/vnd.mobius.plc","plc");
  	mimeToExt.put("application/vnd.mobius.txf","txf");
  	mimeToExt.put("application/vnd.mophun.application","mpn");
  	mimeToExt.put("application/vnd.mophun.certificate","mpc");
  	mimeToExt.put("application/vnd.mozilla.xul+xml","xul");
  	mimeToExt.put("application/vnd.ms-artgalry","cil");
  	mimeToExt.put("application/vnd.ms-cab-compressed","cab");
  	mimeToExt.put("application/vnd.ms-excel","xls");
  	mimeToExt.put("application/vnd.ms-excel.addin.macroenabled.12","xlam");
  	mimeToExt.put("application/vnd.ms-excel.sheet.binary.macroenabled.12","xlsb");
  	mimeToExt.put("application/vnd.ms-excel.sheet.macroenabled.12","xlsm");
  	mimeToExt.put("application/vnd.ms-excel.template.macroenabled.12","xltm");
  	mimeToExt.put("application/vnd.ms-fontobject","eot");
  	mimeToExt.put("application/vnd.ms-htmlhelp","chm");
  	mimeToExt.put("application/vnd.ms-ims","ims");
  	mimeToExt.put("application/vnd.ms-lrm","lrm");
  	mimeToExt.put("application/vnd.ms-officetheme","thmx");
  	mimeToExt.put("application/vnd.ms-pki.seccat","cat");
  	mimeToExt.put("application/vnd.ms-pki.stl","stl");
  	mimeToExt.put("application/vnd.ms-powerpoint","ppt");
  	mimeToExt.put("application/vnd.ms-powerpoint.addin.macroenabled.12","ppam");
  	mimeToExt.put("application/vnd.ms-powerpoint.presentation.macroenabled.12","pptm");
  	mimeToExt.put("application/vnd.ms-powerpoint.slide.macroenabled.12","sldm");
  	mimeToExt.put("application/vnd.ms-powerpoint.slideshow.macroenabled.12","ppsm");
  	mimeToExt.put("application/vnd.ms-powerpoint.template.macroenabled.12","potm");
  	mimeToExt.put("application/vnd.ms-project","mpp");
  	mimeToExt.put("application/vnd.ms-word.document.macroenabled.12","docm");
  	mimeToExt.put("application/vnd.ms-word.template.macroenabled.12","dotm");
  	mimeToExt.put("application/vnd.ms-works","wps");
  	mimeToExt.put("application/vnd.ms-wpl","wpl");
  	mimeToExt.put("application/vnd.ms-xpsdocument","xps");
  	mimeToExt.put("application/vnd.mseq","mseq");
  	mimeToExt.put("application/vnd.musician","mus");
  	mimeToExt.put("application/vnd.muvee.style","msty");
  	mimeToExt.put("application/vnd.mynfc","taglet");
  	mimeToExt.put("application/vnd.neurolanguage.nlu","nlu");
  	mimeToExt.put("application/vnd.nitf","ntf");
  	mimeToExt.put("application/vnd.noblenet-directory","nnd");
  	mimeToExt.put("application/vnd.noblenet-sealer","nns");
  	mimeToExt.put("application/vnd.noblenet-web","nnw");
  	mimeToExt.put("application/vnd.nokia.n-gage.data","ngdat");
  	mimeToExt.put("application/vnd.nokia.n-gage.symbian.install","n");
  	mimeToExt.put("application/vnd.nokia.radio-preset","rpst");
  	mimeToExt.put("application/vnd.nokia.radio-presets","rpss");
  	mimeToExt.put("application/vnd.novadigm.edm","edm");
  	mimeToExt.put("application/vnd.novadigm.edx","edx");
  	mimeToExt.put("application/vnd.novadigm.ext","ext");
  	mimeToExt.put("application/vnd.oasis.opendocument.chart","odc");
  	mimeToExt.put("application/vnd.oasis.opendocument.chart-template","otc");
  	mimeToExt.put("application/vnd.oasis.opendocument.database","odb");
  	mimeToExt.put("application/vnd.oasis.opendocument.formula","odf");
  	mimeToExt.put("application/vnd.oasis.opendocument.formula-template","odft");
  	mimeToExt.put("application/vnd.oasis.opendocument.graphics","odg");
  	mimeToExt.put("application/vnd.oasis.opendocument.graphics-template","otg");
  	mimeToExt.put("application/vnd.oasis.opendocument.image","odi");
  	mimeToExt.put("application/vnd.oasis.opendocument.image-template","oti");
  	mimeToExt.put("application/vnd.oasis.opendocument.presentation","odp");
  	mimeToExt.put("application/vnd.oasis.opendocument.presentation-template","otp");
  	mimeToExt.put("application/vnd.oasis.opendocument.spreadsheet","ods");
  	mimeToExt.put("application/vnd.oasis.opendocument.spreadsheet-template","ots");
  	mimeToExt.put("application/vnd.oasis.opendocument.text","odt");
  	mimeToExt.put("application/vnd.oasis.opendocument.text-master","odm");
  	mimeToExt.put("application/vnd.oasis.opendocument.text-template","ott");
  	mimeToExt.put("application/vnd.oasis.opendocument.text-web","oth");
  	mimeToExt.put("application/vnd.olpc-sugar","xo");
  	mimeToExt.put("application/vnd.oma.dd2+xml","dd2");
  	mimeToExt.put("application/vnd.openofficeorg.extension","oxt");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.presentationml.presentation","pptx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.presentationml.slide","sldx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.presentationml.slideshow","ppsx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.presentationml.template","potx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","xlsx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.spreadsheetml.template","xltx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.wordprocessingml.document","docx");
  	mimeToExt.put("application/vnd.openxmlformats-officedocument.wordprocessingml.template","dotx");
  	mimeToExt.put("application/vnd.osgeo.mapguide.package","mgp");
  	mimeToExt.put("application/vnd.osgi.dp","dp");
  	mimeToExt.put("application/vnd.osgi.subsystem","esa");
  	mimeToExt.put("application/vnd.palm","pdb");
  	mimeToExt.put("application/vnd.pawaafile","paw");
  	mimeToExt.put("application/vnd.pg.format","str");
  	mimeToExt.put("application/vnd.pg.osasli","ei6");
  	mimeToExt.put("application/vnd.picsel","efif");
  	mimeToExt.put("application/vnd.pmi.widget","wg");
  	mimeToExt.put("application/vnd.pocketlearn","plf");
  	mimeToExt.put("application/vnd.powerbuilder6","pbd");
  	mimeToExt.put("application/vnd.previewsystems.box","box");
  	mimeToExt.put("application/vnd.proteus.magazine","mgz");
  	mimeToExt.put("application/vnd.publishare-delta-tree","qps");
  	mimeToExt.put("application/vnd.pvi.ptid1","ptid");
  	mimeToExt.put("application/vnd.quark.quarkxpress","qxd");
  	mimeToExt.put("application/vnd.realvnc.bed","bed");
  	mimeToExt.put("application/vnd.recordare.musicxml","mxl");
  	mimeToExt.put("application/vnd.recordare.musicxml+xml","musicxml");
  	mimeToExt.put("application/vnd.rig.cryptonote","cryptonote");
  	mimeToExt.put("application/vnd.rim.cod","cod");
  	mimeToExt.put("application/vnd.rn-realmedia","rm");
  	mimeToExt.put("application/vnd.rn-realmedia-vbr","rmvb");
  	mimeToExt.put("application/vnd.route66.link66+xml","link66");
  	mimeToExt.put("application/vnd.sailingtracker.track","st");
  	mimeToExt.put("application/vnd.seemail","see");
  	mimeToExt.put("application/vnd.sema","sema");
  	mimeToExt.put("application/vnd.semd","semd");
  	mimeToExt.put("application/vnd.semf","semf");
  	mimeToExt.put("application/vnd.shana.informed.formdata","ifm");
  	mimeToExt.put("application/vnd.shana.informed.formtemplate","itp");
  	mimeToExt.put("application/vnd.shana.informed.interchange","iif");
  	mimeToExt.put("application/vnd.shana.informed.package","ipk");
  	mimeToExt.put("application/vnd.simtech-mindmapper","twd");
  	mimeToExt.put("application/vnd.smaf","mmf");
  	mimeToExt.put("application/vnd.smart.teacher","teacher");
  	mimeToExt.put("application/vnd.solent.sdkm+xml","sdkm");
  	mimeToExt.put("application/vnd.spotfire.dxp","dxp");
  	mimeToExt.put("application/vnd.spotfire.sfs","sfs");
  	mimeToExt.put("application/vnd.stardivision.calc","sdc");
  	mimeToExt.put("application/vnd.stardivision.draw","sda");
  	mimeToExt.put("application/vnd.stardivision.impress","sdd");
  	mimeToExt.put("application/vnd.stardivision.math","smf");
  	mimeToExt.put("application/vnd.stardivision.writer","sdw");
  	mimeToExt.put("application/vnd.stardivision.writer-global","sgl");
  	mimeToExt.put("application/vnd.stepmania.package","smzip");
  	mimeToExt.put("application/vnd.stepmania.stepchart","sm");
  	mimeToExt.put("application/vnd.sun.xml.calc","sxc");
  	mimeToExt.put("application/vnd.sun.xml.calc.template","stc");
  	mimeToExt.put("application/vnd.sun.xml.draw","sxd");
  	mimeToExt.put("application/vnd.sun.xml.draw.template","std");
  	mimeToExt.put("application/vnd.sun.xml.impress","sxi");
  	mimeToExt.put("application/vnd.sun.xml.impress.template","sti");
  	mimeToExt.put("application/vnd.sun.xml.math","sxm");
  	mimeToExt.put("application/vnd.sun.xml.writer","sxw");
  	mimeToExt.put("application/vnd.sun.xml.writer.global","sxg");
  	mimeToExt.put("application/vnd.sun.xml.writer.template","stw");
  	mimeToExt.put("application/vnd.sus-calendar","sus");
  	mimeToExt.put("application/vnd.svd","svd");
  	mimeToExt.put("application/vnd.symbian.install","sis");
  	mimeToExt.put("application/vnd.syncml+xml","xsm");
  	mimeToExt.put("application/vnd.syncml.dm+wbxml","bdm");
  	mimeToExt.put("application/vnd.syncml.dm+xml","xdm");
  	mimeToExt.put("application/vnd.tao.intent-module-archive","tao");
  	mimeToExt.put("application/vnd.tcpdump.pcap","pcap");
  	mimeToExt.put("application/vnd.tmobile-livetv","tmo");
  	mimeToExt.put("application/vnd.trid.tpt","tpt");
  	mimeToExt.put("application/vnd.triscape.mxs","mxs");
  	mimeToExt.put("application/vnd.trueapp","tra");
  	mimeToExt.put("application/vnd.ufdl","ufd");
  	mimeToExt.put("application/vnd.uiq.theme","utz");
  	mimeToExt.put("application/vnd.umajin","umj");
  	mimeToExt.put("application/vnd.unity","unityweb");
  	mimeToExt.put("application/vnd.uoml+xml","uoml");
  	mimeToExt.put("application/vnd.vcx","vcx");
  	mimeToExt.put("application/vnd.visio","vsd");
  	mimeToExt.put("application/vnd.visionary","vis");
  	mimeToExt.put("application/vnd.vsf","vsf");
  	mimeToExt.put("application/vnd.wap.wbxml","wbxml");
  	mimeToExt.put("application/vnd.wap.wmlc","wmlc");
  	mimeToExt.put("application/vnd.wap.wmlscriptc","wmlsc");
  	mimeToExt.put("application/vnd.webturbo","wtb");
  	mimeToExt.put("application/vnd.wolfram.player","nbp");
  	mimeToExt.put("application/vnd.wordperfect","wpd");
  	mimeToExt.put("application/vnd.wqd","wqd");
  	mimeToExt.put("application/vnd.wt.stf","stf");
  	mimeToExt.put("application/vnd.xara","xar");
  	mimeToExt.put("application/vnd.xfdl","xfdl");
  	mimeToExt.put("application/vnd.yamaha.hv-dic","hvd");
  	mimeToExt.put("application/vnd.yamaha.hv-script","hvs");
  	mimeToExt.put("application/vnd.yamaha.hv-voice","hvp");
  	mimeToExt.put("application/vnd.yamaha.openscoreformat","osf");
  	mimeToExt.put("application/vnd.yamaha.openscoreformat.osfpvg+xml","osfpvg");
  	mimeToExt.put("application/vnd.yamaha.smaf-audio","saf");
  	mimeToExt.put("application/vnd.yamaha.smaf-phrase","spf");
  	mimeToExt.put("application/vnd.yellowriver-custom-menu","cmp");
  	mimeToExt.put("application/vnd.zul","zir");
  	mimeToExt.put("application/vnd.zzazz.deck+xml","zaz");
  	mimeToExt.put("application/voicexml+xml","vxml");
  	mimeToExt.put("application/widget","wgt");
  	mimeToExt.put("application/winhlp","hlp");
  	mimeToExt.put("application/wsdl+xml","wsdl");
  	mimeToExt.put("application/wspolicy+xml","wspolicy");
  	mimeToExt.put("application/x-7z-compressed","7z");
  	mimeToExt.put("application/x-abiword","abw");
  	mimeToExt.put("application/x-ace-compressed","ace");
  	mimeToExt.put("application/x-apple-diskimage","dmg");
  	mimeToExt.put("application/x-authorware-bin","aab");
  	mimeToExt.put("application/x-authorware-map","aam");
  	mimeToExt.put("application/x-authorware-seg","aas");
  	mimeToExt.put("application/x-bcpio","bcpio");
  	mimeToExt.put("application/x-bittorrent","torrent");
  	mimeToExt.put("application/x-blorb","blb");
  	mimeToExt.put("application/x-bzip","bz");
  	mimeToExt.put("application/x-bzip2","bz2");
  	mimeToExt.put("application/x-cbr","cbr");
  	mimeToExt.put("application/x-cdlink","vcd");
  	mimeToExt.put("application/x-cfs-compressed","cfs");
  	mimeToExt.put("application/x-chat","chat");
  	mimeToExt.put("application/x-chess-pgn","pgn");
  	mimeToExt.put("application/x-conference","nsc");
  	mimeToExt.put("application/x-cpio","cpio");
  	mimeToExt.put("application/x-csh","csh");
  	mimeToExt.put("application/x-debian-package","deb");
  	mimeToExt.put("application/x-dgc-compressed","dgc");
  	mimeToExt.put("application/x-director","dir");
  	mimeToExt.put("application/x-doom","wad");
  	mimeToExt.put("application/x-dtbncx+xml","ncx");
  	mimeToExt.put("application/x-dtbook+xml","dtb");
  	mimeToExt.put("application/x-dtbresource+xml","res");
  	mimeToExt.put("application/x-dvi","dvi");
  	mimeToExt.put("application/x-envoy","evy");
  	mimeToExt.put("application/x-eva","eva");
  	mimeToExt.put("application/x-font-bdf","bdf");
  	mimeToExt.put("application/x-font-ghostscript","gsf");
  	mimeToExt.put("application/x-font-linux-psf","psf");
  	mimeToExt.put("application/x-font-otf","otf");
  	mimeToExt.put("application/x-font-pcf","pcf");
  	mimeToExt.put("application/x-font-snf","snf");
  	mimeToExt.put("application/x-font-ttf","ttf");
  	mimeToExt.put("application/x-font-type1","pfa");
  	mimeToExt.put("application/font-woff","woff");
  	mimeToExt.put("application/x-freearc","arc");
  	mimeToExt.put("application/x-futuresplash","spl");
  	mimeToExt.put("application/x-gca-compressed","gca");
  	mimeToExt.put("application/x-glulx","ulx");
  	mimeToExt.put("application/x-gnumeric","gnumeric");
  	mimeToExt.put("application/x-gramps-xml","gramps");
  	mimeToExt.put("application/x-gtar","gtar");
  	mimeToExt.put("application/x-hdf","hdf");
  	mimeToExt.put("application/x-install-instructions","install");
  	mimeToExt.put("application/x-iso9660-image","iso");
  	mimeToExt.put("application/x-java-jnlp-file","jnlp");
  	mimeToExt.put("application/x-latex","latex");
  	mimeToExt.put("application/x-lzh-compressed","lzh");
  	mimeToExt.put("application/x-mie","mie");
  	mimeToExt.put("application/x-mobipocket-ebook","prc");
  	mimeToExt.put("application/x-ms-application","application");
  	mimeToExt.put("application/x-ms-shortcut","lnk");
  	mimeToExt.put("application/x-ms-wmd","wmd");
  	mimeToExt.put("application/x-ms-wmz","wmz");
  	mimeToExt.put("application/x-ms-xbap","xbap");
  	mimeToExt.put("application/x-msaccess","mdb");
  	mimeToExt.put("application/x-msbinder","obd");
  	mimeToExt.put("application/x-mscardfile","crd");
  	mimeToExt.put("application/x-msclip","clp");
  	mimeToExt.put("application/x-msdownload","exe");
  	mimeToExt.put("application/x-msmediaview","mvb");
  	mimeToExt.put("application/x-msmetafile","wmf");
  	mimeToExt.put("application/x-msmoney","mny");
  	mimeToExt.put("application/x-mspublisher","pub");
  	mimeToExt.put("application/x-msschedule","scd");
  	mimeToExt.put("application/x-msterminal","trm");
  	mimeToExt.put("application/x-mswrite","wri");
  	mimeToExt.put("application/x-netcdf","nc");
  	mimeToExt.put("application/x-nzb","nzb");
  	mimeToExt.put("application/x-pkcs12","p12");
  	mimeToExt.put("application/x-pkcs7-certificates","p7b");
  	mimeToExt.put("application/x-pkcs7-certreqresp","p7r");
  	mimeToExt.put("application/x-rar-compressed","rar");
  	mimeToExt.put("application/x-research-info-systems","ris");
  	mimeToExt.put("application/x-sh","sh");
  	mimeToExt.put("application/x-shar","shar");
  	mimeToExt.put("application/x-shockwave-flash","swf");
  	mimeToExt.put("application/x-silverlight-app","xap");
  	mimeToExt.put("application/x-sql","sql");
  	mimeToExt.put("application/x-stuffit","sit");
  	mimeToExt.put("application/x-stuffitx","sitx");
  	mimeToExt.put("application/x-subrip","srt");
  	mimeToExt.put("application/x-sv4cpio","sv4cpio");
  	mimeToExt.put("application/x-sv4crc","sv4crc");
  	mimeToExt.put("application/x-t3vm-image","t3");
  	mimeToExt.put("application/x-tads","gam");
  	mimeToExt.put("application/x-tar","tar");
  	mimeToExt.put("application/x-tcl","tcl");
  	mimeToExt.put("application/x-tex","tex");
  	mimeToExt.put("application/x-tex-tfm","tfm");
  	mimeToExt.put("application/x-texinfo","texinfo");
  	mimeToExt.put("application/x-tgif","obj");
  	mimeToExt.put("application/x-ustar","ustar");
  	mimeToExt.put("application/x-wais-source","src");
  	mimeToExt.put("application/x-x509-ca-cert","der");
  	mimeToExt.put("application/x-xfig","fig");
  	mimeToExt.put("application/x-xliff+xml","xlf");
  	mimeToExt.put("application/x-xpinstall","xpi");
  	mimeToExt.put("application/x-xz","xz");
  	mimeToExt.put("application/x-zmachine","z1");
  	mimeToExt.put("application/xaml+xml","xaml");
  	mimeToExt.put("application/xcap-diff+xml","xdf");
  	mimeToExt.put("application/xenc+xml","xenc");
  	mimeToExt.put("application/xhtml+xml","xhtml");
  	mimeToExt.put("application/xml","xml");
  	mimeToExt.put("application/xml-dtd","dtd");
  	mimeToExt.put("application/xop+xml","xop");
  	mimeToExt.put("application/xproc+xml","xpl");
  	mimeToExt.put("application/xslt+xml","xslt");
  	mimeToExt.put("application/xspf+xml","xspf");
  	mimeToExt.put("application/xv+xml","mxml");
  	mimeToExt.put("application/yang","yang");
  	mimeToExt.put("application/yin+xml","yin");
  	mimeToExt.put("application/zip","zip");
  	mimeToExt.put("audio/adpcm","adp");
  	mimeToExt.put("audio/basic","au");
  	mimeToExt.put("audio/midi","mid");
  	mimeToExt.put("audio/mp4","mp4a");
  	mimeToExt.put("audio/mpeg","mpga");
  	mimeToExt.put("audio/ogg","oga");
  	mimeToExt.put("audio/s3m","s3m");
  	mimeToExt.put("audio/silk","sil");
  	mimeToExt.put("audio/vnd.dece.audio","uva");
  	mimeToExt.put("audio/vnd.digital-winds","eol");
  	mimeToExt.put("audio/vnd.dra","dra");
  	mimeToExt.put("audio/vnd.dts","dts");
  	mimeToExt.put("audio/vnd.dts.hd","dtshd");
  	mimeToExt.put("audio/vnd.lucent.voice","lvp");
  	mimeToExt.put("audio/vnd.ms-playready.media.pya","pya");
  	mimeToExt.put("audio/vnd.nuera.ecelp4800","ecelp4800");
  	mimeToExt.put("audio/vnd.nuera.ecelp7470","ecelp7470");
  	mimeToExt.put("audio/vnd.nuera.ecelp9600","ecelp9600");
  	mimeToExt.put("audio/vnd.rip","rip");
  	mimeToExt.put("audio/webm","weba");
  	mimeToExt.put("audio/x-aac","aac");
  	mimeToExt.put("audio/x-aiff","aif");
  	mimeToExt.put("audio/x-caf","caf");
  	mimeToExt.put("audio/x-flac","flac");
  	mimeToExt.put("audio/x-matroska","mka");
  	mimeToExt.put("audio/x-mpegurl","m3u");
  	mimeToExt.put("audio/x-ms-wax","wax");
  	mimeToExt.put("audio/x-ms-wma","wma");
  	mimeToExt.put("audio/x-pn-realaudio","ram");
  	mimeToExt.put("audio/x-pn-realaudio-plugin","rmp");
  	mimeToExt.put("audio/x-wav","wav");
  	mimeToExt.put("audio/xm","xm");
  	mimeToExt.put("chemical/x-cdx","cdx");
  	mimeToExt.put("chemical/x-cif","cif");
  	mimeToExt.put("chemical/x-cmdf","cmdf");
  	mimeToExt.put("chemical/x-cml","cml");
  	mimeToExt.put("chemical/x-csml","csml");
  	mimeToExt.put("chemical/x-xyz","xyz");
  	mimeToExt.put("image/bmp","bmp");
  	mimeToExt.put("image/cgm","cgm");
  	mimeToExt.put("image/g3fax","g3");
  	mimeToExt.put("image/gif","gif");
  	mimeToExt.put("image/ief","ief");
  	mimeToExt.put("image/jpeg","jpeg");
  	mimeToExt.put("image/ktx","ktx");
  	mimeToExt.put("image/png","png");
  	mimeToExt.put("image/prs.btif","btif");
  	mimeToExt.put("image/sgi","sgi");
  	mimeToExt.put("image/svg+xml","svg");
  	mimeToExt.put("image/tiff","tiff");
  	mimeToExt.put("image/vnd.adobe.photoshop","psd");
  	mimeToExt.put("image/vnd.dece.graphic","uvi");
  	mimeToExt.put("image/vnd.dvb.subtitle","sub");
  	mimeToExt.put("image/vnd.djvu","djvu");
  	mimeToExt.put("image/vnd.dwg","dwg");
  	mimeToExt.put("image/vnd.dxf","dxf");
  	mimeToExt.put("image/vnd.fastbidsheet","fbs");
  	mimeToExt.put("image/vnd.fpx","fpx");
  	mimeToExt.put("image/vnd.fst","fst");
  	mimeToExt.put("image/vnd.fujixerox.edmics-mmr","mmr");
  	mimeToExt.put("image/vnd.fujixerox.edmics-rlc","rlc");
  	mimeToExt.put("image/vnd.ms-modi","mdi");
  	mimeToExt.put("image/vnd.ms-photo","wdp");
  	mimeToExt.put("image/vnd.net-fpx","npx");
  	mimeToExt.put("image/vnd.wap.wbmp","wbmp");
  	mimeToExt.put("image/vnd.xiff","xif");
  	mimeToExt.put("image/webp","webp");
  	mimeToExt.put("image/x-3ds","3ds");
  	mimeToExt.put("image/x-cmu-raster","ras");
  	mimeToExt.put("image/x-cmx","cmx");
  	mimeToExt.put("image/x-freehand","fh");
  	mimeToExt.put("image/x-icon","ico");
  	mimeToExt.put("image/x-mrsid-image","sid");
  	mimeToExt.put("image/x-pcx","pcx");
  	mimeToExt.put("image/x-pict","pic");
  	mimeToExt.put("image/x-portable-anymap","pnm");
  	mimeToExt.put("image/x-portable-bitmap","pbm");
  	mimeToExt.put("image/x-portable-graymap","pgm");
  	mimeToExt.put("image/x-portable-pixmap","ppm");
  	mimeToExt.put("image/x-rgb","rgb");
  	mimeToExt.put("image/x-tga","tga");
  	mimeToExt.put("image/x-xbitmap","xbm");
  	mimeToExt.put("image/x-xpixmap","xpm");
  	mimeToExt.put("image/x-xwindowdump","xwd");
  	mimeToExt.put("message/rfc822","eml");
  	mimeToExt.put("model/iges","igs");
  	mimeToExt.put("model/mesh","msh");
  	mimeToExt.put("model/vnd.collada+xml","dae");
  	mimeToExt.put("model/vnd.dwf","dwf");
  	mimeToExt.put("model/vnd.gdl","gdl");
  	mimeToExt.put("model/vnd.gtw","gtw");
  	mimeToExt.put("model/vnd.mts","mts");
  	mimeToExt.put("model/vnd.vtu","vtu");
  	mimeToExt.put("model/vrml","wrl");
  	mimeToExt.put("model/x3d+binary","x3db");
  	mimeToExt.put("model/x3d+vrml","x3dv");
  	mimeToExt.put("model/x3d+xml","x3d");
  	mimeToExt.put("text/cache-manifest","appcache");
  	mimeToExt.put("text/calendar","ics");
  	mimeToExt.put("text/css","css");
  	mimeToExt.put("text/csv","csv");
  	mimeToExt.put("text/html","html");
  	mimeToExt.put("text/n3","n3");
  	mimeToExt.put("text/plain","txt");
  	mimeToExt.put("text/prs.lines.tag","dsc");
  	mimeToExt.put("text/richtext","rtx");
  	mimeToExt.put("text/sgml","sgml");
  	mimeToExt.put("text/tab-separated-values","tsv");
  	mimeToExt.put("text/troff","t");
  	mimeToExt.put("text/turtle","ttl");
  	mimeToExt.put("text/uri-list","uri");
  	mimeToExt.put("text/vcard","vcard");
  	mimeToExt.put("text/vnd.curl","curl");
  	mimeToExt.put("text/vnd.curl.dcurl","dcurl");
  	mimeToExt.put("text/vnd.curl.scurl","scurl");
  	mimeToExt.put("text/vnd.curl.mcurl","mcurl");
  	mimeToExt.put("text/vnd.dvb.subtitle","sub");
  	mimeToExt.put("text/vnd.fly","fly");
  	mimeToExt.put("text/vnd.fmi.flexstor","flx");
  	mimeToExt.put("text/vnd.graphviz","gv");
  	mimeToExt.put("text/vnd.in3d.3dml","3dml");
  	mimeToExt.put("text/vnd.in3d.spot","spot");
  	mimeToExt.put("text/vnd.sun.j2me.app-descriptor","jad");
  	mimeToExt.put("text/vnd.wap.wml","wml");
  	mimeToExt.put("text/vnd.wap.wmlscript","wmls");
  	mimeToExt.put("text/x-asm","s");
  	mimeToExt.put("text/x-c","c");
  	mimeToExt.put("text/x-fortran","f");
  	mimeToExt.put("text/x-java-source","java");
  	mimeToExt.put("text/x-opml","opml");
  	mimeToExt.put("text/x-pascal","p");
  	mimeToExt.put("text/x-nfo","nfo");
  	mimeToExt.put("text/x-setext","etx");
  	mimeToExt.put("text/x-sfv","sfv");
  	mimeToExt.put("text/x-uuencode","uu");
  	mimeToExt.put("text/x-vcalendar","vcs");
  	mimeToExt.put("text/x-vcard","vcf");
  	mimeToExt.put("video/3gpp","3gp");
  	mimeToExt.put("video/3gpp2","3g2");
  	mimeToExt.put("video/h261","h261");
  	mimeToExt.put("video/h263","h263");
  	mimeToExt.put("video/h264","h264");
  	mimeToExt.put("video/jpeg","jpgv");
  	mimeToExt.put("video/jpm","jpm");
  	mimeToExt.put("video/mj2","mj2");
  	mimeToExt.put("video/mp4","mp4");
  	mimeToExt.put("video/mpeg","mpeg");
  	mimeToExt.put("video/ogg","ogv");
  	mimeToExt.put("video/quicktime","qt");
  	mimeToExt.put("video/vnd.dece.hd","uvh");
  	mimeToExt.put("video/vnd.dece.mobile","uvm");
  	mimeToExt.put("video/vnd.dece.pd","uvp");
  	mimeToExt.put("video/vnd.dece.sd","uvs");
  	mimeToExt.put("video/vnd.dece.video","uvv");
  	mimeToExt.put("video/vnd.dvb.file","dvb");
  	mimeToExt.put("video/vnd.fvt","fvt");
  	mimeToExt.put("video/vnd.mpegurl","mxu");
  	mimeToExt.put("video/vnd.ms-playready.media.pyv","pyv");
  	mimeToExt.put("video/vnd.uvvu.mp4","uvu");
  	mimeToExt.put("video/vnd.vivo","viv");
  	mimeToExt.put("video/webm","webm");
  	mimeToExt.put("video/x-f4v","f4v");
  	mimeToExt.put("video/x-fli","fli");
  	mimeToExt.put("video/x-flv","flv");
  	mimeToExt.put("video/x-m4v","m4v");
  	mimeToExt.put("video/x-matroska","mkv");
  	mimeToExt.put("video/x-mng","mng");
  	mimeToExt.put("video/x-ms-asf","asf");
  	mimeToExt.put("video/x-ms-vob","vob");
  	mimeToExt.put("video/x-ms-wm","wm");
  	mimeToExt.put("video/x-ms-wmv","wmv");
  	mimeToExt.put("video/x-ms-wmx","wmx");
  	mimeToExt.put("video/x-ms-wvx","wvx");
  	mimeToExt.put("video/x-msvideo","avi");
  	mimeToExt.put("video/x-sgi-movie","movie");
  	mimeToExt.put("video/x-smv","smv");
  	mimeToExt.put("x-conference/x-cooltalk","ice");
  }      
}
