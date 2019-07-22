void cat_asimovs(char const *outputfile, char const *inputfile,
                 char const *inputhisto, char const *varsdir,
                 char const *expdir, char const *asmdir) {

  TFile *fin = TFile::Open(inputfile, "READ");
  TH2 *hin;
  fin->GetObject(inputhisto, hin);

  if (!hin) {
    std::cout << "Failed to find " << inputhisto << " in " << inputfile
              << std::endl;
    return;
  }

  hin = (TH2 *)hin->Clone();
  hin->SetDirectory(nullptr);

  TFile *fout = TFile::Open(outputfile, "UPDATE");
  fout->cd();

  if (!gDirectory->GetDirectory(varsdir)) {
    gDirectory->mkdir(varsdir)
  }
  gDirectory->GetDirectory(varsdir)->cd();

  if (!gDirectory->GetDirectory(expdir)) {
    gDirectory->mkdir(expdir)
  }
  gDirectory->GetDirectory(expdir)->cd();

  if (!gDirectory->GetDirectory(asmdir)) {
    gDirectory->mkdir(asmdir)
  }
  gDirectory->GetDirectory(asmdir)->cd();

  gDirectory->WriteTObject(hin);

  fout->Write();
  fout->Close();
}
