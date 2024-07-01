class DataEntry {
  int peakLabel;
  num channelStart;
  num channelEnd;
  int peak;
  int totalCounts;
  String relatedROI;
  int positionStdDev;
  String fwhmDevKEV;
  String fwhmDevChn;
  String fwhmDevPct;
  String areaStdDev;
  String option;
  String fit;
  String identifiedPeak;

  DataEntry({
    this.peakLabel = 0,
    this.channelStart = 0,
    this.channelEnd = 0,
    this.peak = 0,
    this.totalCounts = 0,
    this.relatedROI = 'N/A',
    this.positionStdDev = 0,
    this.fwhmDevKEV = 'N/A',
    this.fwhmDevChn = 'N/A',
    this.fwhmDevPct = 'N/A',
    this.areaStdDev = 'N/A',
    this.option = 'N/A',
    this.fit = 'N/A',
    this.identifiedPeak = 'N/A',
  });

  // Method to convert to map
  Map<String, dynamic> toMap() {
    return {
      'Peak Label': peakLabel,
      'Channel Start': channelStart,
      'Channel End': channelEnd,
      'Peak': peak,
      'Total Counts': totalCounts,
      'Related ROI': relatedROI,
      'Position|Std.Dev(chn)': positionStdDev,
      'FWHM|Std.dev(kEV)': fwhmDevKEV,
      'FWHM|Std.Dev(chn)': fwhmDevChn,
      'FWHM|Std.Dev(%)': fwhmDevPct,
      'Area|Std.Dev': areaStdDev,
      'Option': option,
      'Fit': fit,
      'Identified Peak': identifiedPeak,
    };
  }
}
