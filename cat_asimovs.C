void cat_asimovs(char const *outputfile, char const *inputfile, char const *inputhisto, char const *varsdir,char const *expdir,char const *asmdir){

  TFile *fin = TFile::Open(inputfile,"READ");
  TH2 *hin;
  fin->GetObject(inputhisto, hin);

  if(!hin){
    std::cout << "Failed to find " << inputhisto << " in " << inputfile << std::endl;
    return;
  }

  hin = (TH2*)hin->Clone();
  hin->SetDirectory(nullptr);

  TFile *fout = TFile::Open(outputfile,"UPDATE");
  fout->cd();

  gDirectory->mkdir(varsdir)->cd();
  gDirectory->mkdir(expdir)->cd();
  gDirectory->mkdir(asmdir)->cd();

  gDirectory->WriteTObject(hin);

  fout->Write();
  fout->Close();

}
