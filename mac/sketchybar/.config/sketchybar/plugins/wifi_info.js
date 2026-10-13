// Prints the current Wi-Fi state, one field per line (empty if unknown):
//   device, power (1|0), link active (1|0), rssi (dBm), ipv4, ssid
// Prints nothing if the machine has no Wi-Fi interface.
//
// Why JXA instead of networksetup/ipconfig/airport?
//   Since macOS 14.4 the SSID is redacted ("<redacted>" / "not associated")
//   for any process without Location Services permission, and the `airport`
//   CLI is gone. This script:
//     - asks CoreWLAN for power + live RSSI (no permission required)
//     - reads the SSID from the system's cached scan record in the
//       SystemConfiguration dynamic store (readable without sudo)
//   osascript ships with macOS, so no Xcode tools / python are needed.

ObjC.import("CoreWLAN");
ObjC.import("SystemConfiguration");

function storeValue(key) {
  var ref = $.SCDynamicStoreCopyValue(null, $(key));
  if (!ref || ref.isNil && ref.isNil()) return null;
  var obj = ObjC.castRefToObject(ref);
  return obj && !obj.isNil() ? obj : null;
}

function str(nsObj) {
  if (!nsObj || nsObj.isNil()) return "";
  var s = ObjC.unwrap(nsObj);
  return typeof s === "string" ? s : "";
}

function ssidFromAirport(airport) {
  if (!airport) return "";

  // Older macOS (or if this process ever gets location access): plain string.
  var plain = str(airport.objectForKey("SSID_STR"));
  if (plain) return plain;

  // macOS 14.4+: SSID_STR is blanked, but the archived scan record of the
  // associated network still contains it.
  try {
    var rec = airport.objectForKey("CachedScanRecord");
    if (!rec || rec.isNil()) return "";
    var scan = $.NSKeyedUnarchiver.unarchiveObjectWithData(rec);
    if (!scan || scan.isNil()) return "";
    return str(scan.objectForKey("SSID_STR"));
  } catch (e) {
    return "";
  }
}

function firstIPv4(dev) {
  var ipv4 = storeValue("State:/Network/Interface/" + dev + "/IPv4");
  if (!ipv4) return "";
  var addrs = ipv4.objectForKey("Addresses");
  if (!addrs || addrs.isNil() || addrs.count === 0) return "";
  return str(addrs.objectAtIndex(0));
}

function run() {
  var iface = $.CWWiFiClient.sharedWiFiClient.interface;
  if (!iface || iface.isNil()) return ""; // no Wi-Fi hardware

  var dev = str(iface.interfaceName);
  var power = iface.powerOn ? 1 : 0;
  var rssi = Number(iface.rssiValue) || 0;

  var link = storeValue("State:/Network/Interface/" + dev + "/Link");
  var active = link && ObjC.unwrap(link.objectForKey("Active")) ? 1 : 0;

  var ssid = "";
  var ip = "";
  if (power && active) {
    ssid = str(iface.ssid) || ssidFromAirport(storeValue("State:/Network/Interface/" + dev + "/AirPort"));
    ip = firstIPv4(dev);
  }

  // One field per line, so make sure the SSID can't span lines.
  ssid = ssid.replace(/[\r\n]/g, " ");

  return [dev, power, active, rssi, ip, ssid].join("\n");
}
