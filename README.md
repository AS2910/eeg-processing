# eeg-processing
This contains a generic EEG processing pipeline inspired by the HAPPE pipeline, in Matlab using EEGLab.<br>
The folder structure is stated below:<br>
Main_Folder<br>
 &nbsp;&nbsp;& |Subject1<br>
 &nbsp;&nbsp;&&nbsp;&nbsp;&   |EEG_File1<br>
  &nbsp;&nbsp;&&nbsp;&nbsp;&  |EEG_File2<br>
 &nbsp;&nbsp;&&nbsp;&nbsp;&   |EEG_File3<br>
 &nbsp;&nbsp;&&nbsp;&nbsp;&   |EEG_File4<br>
 &nbsp;&nbsp;&&nbsp;&nbsp;&   |....<br>
 &nbsp;&nbsp;& |Subject2<br>
 &nbsp;&nbsp;&&nbsp;&nbsp;&   |EEG_File1<br>
&nbsp;&nbsp;&&nbsp;&nbsp;&    |EEG_File2<br>
&nbsp;&nbsp;&&nbsp;&nbsp;&    |EEG_File3<br>
&nbsp;&nbsp;&&nbsp;&nbsp;&    |EEG_File4<br>
&nbsp;&nbsp;&&nbsp;&nbsp;&    |....<br>
  &nbsp;&nbsp;&|...<br>
  <br>
  Suggestions:<br>
  1.Play with the artifact removal probability according to requirements/dataset.<br>
  Improvements:<br>
  1. Looking for better ways to implement W-ICA<br>
  
  
  References:<br>
  1. Gabard-Durnam LJ, Mendez Leal AS, Wilkinson CL, Levin AR. The Harvard Automated Processing Pipeline for Electroencephalography (HAPPE): Standardized Processing Software for Developmental and High-Artifact Data. Front Neurosci. 2018;12:97. Published 2018 Feb 27. doi:10.3389/fnins.2018.00097<br>
  
  
