class MatrixTest {
  
  void TestFailure(var output, var expectedOutput, num error) {
    print('FAILURE!!!');
    print('$output != $expectedOutput) : ${error}');
    assert(false);
  }

  void RelativeTest(var output, var expectedOutput) {
    num error = relativeError(output, expectedOutput);
    //print('$output $expectedOutput $error');
    if (error >= errorThreshold) {
      TestFailure(output, expectedOutput, error);
    }
  }
  
  final num errorThreshold = 0.00005;
  
  Dynamic makeMatrix(int rows, int cols) {
    if (cols == 2) {
      if (rows == 2) {
        return new mat2x2();
      }
      if (rows == 3) {
        return new mat2x3();
      }
      if (rows == 4) {
        return new mat2x4();
      }
    }
    if (cols == 3) {
      if (rows == 2) {
        return new mat3x2();
      }
      if (rows == 3) {
        return new mat3x3();
      }
      if (rows == 4) {
        return new mat3x4();
      }
    }
    
    if (cols == 4) {
      if (rows == 2) {
        return new mat4x2();
      }
      if (rows == 3) {
        return new mat4x3();
      }
      if (rows == 4) {
        return new mat4x4();
      }
    }
    
    return null;
  }
  
  Dynamic parseMatrix(String input) {
    input = input.trim();
    List<String> rows = input.split("\n");
    List<double> values = new List<double>();
    int col_count = 0;
    for (int i = 0; i < rows.length; i++) {
      rows[i] = rows[i].trim();
      List<String> cols = rows[i].split(" ");
      for (int j = 0; j < cols.length; j++) {
        cols[j] = cols[j].trim();
      }
      
      for (int j = 0; j < cols.length; j++) {
        if (cols[j].isEmpty()) {
          continue;
        }
        if (i == 0) {
          col_count++;  
        }
        values.add(Math.parseDouble(cols[j]));
      }
    }
    
    Dynamic m = makeMatrix(rows.length, col_count);
    
    for (int j = 0; j < rows.length; j++) {
      for (int i = 0; i < col_count; i++) {
        m[i][j] = values[j*rows.length+i];
      }  
    }
    
    return m;
  }
  
  void Test4x4Det() {
    List<mat4x4> input = new List<mat4x4>();
    List<double> expectedOutput = new List<double>();
    
    input.add(parseMatrix('''0.046171390631154   0.317099480060861   0.381558457093008   0.489764395788231
      0.097131781235848   0.950222048838355   0.765516788149002   0.445586200710899
      0.823457828327293   0.034446080502909   0.795199901137063   0.646313010111265
      0.694828622975817   0.438744359656398   0.186872604554379   0.709364830858073'''));
    expectedOutput.add(-0.199908980087990);
    
    input.add(parseMatrix('''  -2.336158020850647   0.358791716162913   0.571930324052307   0.866477090273158
  -1.190335868711951   1.132044609886021  -0.693048859451418   0.742195189800671
   0.015919048685702   0.552417702663606   1.020805610524362  -1.288062497216858
   3.020318574990609  -1.197139524685751  -0.400475005629390   0.441263145991252'''));
    expectedOutput.add(-5.002276533849802);
    
    assert(input.length == expectedOutput.length);
    
    for (int i = 0; i < input.length; i++) {
      double output = input[i].determinant();
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void Test4x4Adjoint() {
    List<mat4x4> input = new List<mat4x4>();
    List<mat4x4> expectedOutput = new List<mat4x4>();
    input.add(parseMatrix('''0.046171390631154   0.317099480060861   0.381558457093008   0.489764395788231
      0.097131781235848   0.950222048838355   0.765516788149002   0.445586200710899
      0.823457828327293   0.034446080502909   0.795199901137063   0.646313010111265
      0.694828622975817   0.438744359656398   0.186872604554379   0.709364830858073'''));
    
    expectedOutput.add(parseMatrix('''   0.467018967272630  -0.071725686042148  -0.114334007762690  -0.173216551386116
   0.237958829476358  -0.226305883376421   0.138546690644078  -0.148371483419264
  -0.003182360786730  -0.110433259522032  -0.204068208468023   0.257495260108212
  -0.603788805867184   0.239318941402950   0.080058549926103  -0.088212465465529'''));
    
    assert(input.length == expectedOutput.length);
    
    for (int i = 0; i < input.length; i++) {
      mat4x4 output = new mat4x4.copy(input[i]);
      output.selfScaleAdjoint(1.0);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void Test4x4Inversion() {
    List<mat4x4> input = new List<mat4x4>();
    List<mat4x4> expectedOutput = new List<mat4x4>();
    input.add(parseMatrix('''0.046171390631154   0.317099480060861   0.381558457093008   0.489764395788231
   0.097131781235848   0.950222048838355   0.765516788149002   0.445586200710899
   0.823457828327293   0.034446080502909   0.795199901137063   0.646313010111265
   0.694828622975817   0.438744359656398   0.186872604554379   0.709364830858073'''));
    
    expectedOutput.add(parseMatrix('''  -2.336158020850647   0.358791716162913   0.571930324052307   0.866477090273158
  -1.190335868711951   1.132044609886021  -0.693048859451418   0.742195189800671
   0.015919048685702   0.552417702663606   1.020805610524362  -1.288062497216858
   3.020318574990609  -1.197139524685751  -0.400475005629390   0.441263145991252'''));
    
    assert(input.length == expectedOutput.length);
    for (int i = 0; i < input.length; i++) {
      mat4x4 output = new mat4x4.copy(input[i]);
      output.invert();
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void Test4x4MatrixMultiplication() {
    List<mat4x4> inputA = new List<mat4x4>();
    List<mat4x4> inputB = new List<mat4x4>();
    List<mat4x4> expectedOutput = new List<mat4x4>();
    
    inputA.add(parseMatrix('''  0.754686681982361   0.162611735194631   0.340385726666133   0.255095115459269
   0.276025076998578   0.118997681558377   0.585267750979777   0.505957051665142
   0.679702676853675   0.498364051982143   0.223811939491137   0.699076722656686
   0.655098003973841   0.959743958516081   0.751267059305653   0.890903252535798'''));
    inputB.add(parseMatrix('''0.959291425205444   0.257508254123736   0.243524968724989   0.251083857976031
   0.547215529963803   0.840717255983663   0.929263623187228   0.616044676146639
   0.138624442828679   0.254282178971531   0.349983765984809   0.473288848902729
   0.149294005559057   0.814284826068816   0.196595250431208   0.351659507062997'''));
    expectedOutput.add(parseMatrix('''0.898218082886683   0.625322647681513   0.504174187460227   0.540473128734198
   0.486574639653946   0.731938448794797   0.482102179836115   0.597538636973484
   1.060139267944114   1.220171263074055   0.844401866551068   0.829441562288635
   1.390767189418691   1.892049275398817   1.489466491870617   1.424590610642752'''));

    inputA.add(parseMatrix('''0.959291425205444   0.257508254123736   0.243524968724989   0.251083857976031
      0.547215529963803   0.840717255983663   0.929263623187228   0.616044676146639
      0.138624442828679   0.254282178971531   0.349983765984809   0.473288848902729
      0.149294005559057   0.814284826068816   0.196595250431208   0.351659507062997'''));
    inputB.add(parseMatrix('''  0.754686681982361   0.162611735194631   0.340385726666133   0.255095115459269
      0.276025076998578   0.118997681558377   0.585267750979777   0.505957051665142
      0.679702676853675   0.498364051982143   0.223811939491137   0.699076722656686
      0.655098003973841   0.959743958516081   0.751267059305653   0.890903252535798'''));
    
    expectedOutput.add(parseMatrix('''1.125052305727933   0.548975234378873   0.720375212788503   0.768932736659174
   1.680227927840003   1.243383811879966   1.349103419482854   1.763421606786932
   0.722741761644472   0.681456392059569   0.629905807879616   0.830338358796353
   0.701430988639845   0.556654056692266   0.835582765421220   0.900807083387785'''));
    
    assert(inputA.length == inputB.length);
    assert(expectedOutput == inputB.length);
    
    for (int i = 0; i < inputA.length; i++) {
      mat4x4 output = inputA[i] * inputB[i];
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestAdjoint() {
    List<Dynamic> input = new List<Dynamic>();
    List<Dynamic> expectedOutput = new List<Dynamic>();
    
    input.add(parseMatrix(''' 0.285839018820374   0.380445846975357   0.053950118666607
   0.757200229110721   0.567821640725221   0.530797553008973
   0.753729094278495   0.075854289563064   0.779167230102011'''));
    expectedOutput.add(parseMatrix(''' 0.402164743710542  -0.292338588868304   0.171305679728352
  -0.189908046274114   0.182052622470548  -0.110871609529434
  -0.370546805539367   0.265070987960728  -0.125768101844091'''));
    input.add(parseMatrix('''0.830828627896291   0.549723608291140
   0.585264091152724   0.917193663829810'''));
    expectedOutput.add(parseMatrix('''   0.917193663829810  -0.549723608291140
  -0.585264091152724   0.830828627896291'''));
    input.add(parseMatrix('''0.934010684229183   0.011902069501241   0.311215042044805   0.262971284540144
   0.129906208473730   0.337122644398882   0.528533135506213   0.654079098476782
   0.568823660872193   0.162182308193243   0.165648729499781   0.689214503140008
   0.469390641058206   0.794284540683907   0.601981941401637   0.748151592823709'''));
    expectedOutput.add(parseMatrix('''0.104914550911225  -0.120218628213523   0.026180662741638   0.044107217835411
  -0.081375770192194  -0.233925009984709  -0.022194776259965   0.253560794325371
   0.155967414263983   0.300399085119975  -0.261648453454468  -0.076412061081351
  -0.104925204524921   0.082065846290507   0.217666653572481  -0.077704028180558'''));
    input.add(parseMatrix(''' 1     0
     0     1'''));
    expectedOutput.add(parseMatrix(''' 1     0
    0     1'''));
    input.add(parseMatrix('''1     0     0
     0     1     0
     0     0     1'''));
    expectedOutput.add(parseMatrix('''1     0     0
      0     1     0
      0     0     1'''));
    input.add(parseMatrix('''1     0     0     0
     0     1     0     0
     0     0     1     0
     0     0     0     1'''));
    expectedOutput.add(parseMatrix('''1     0     0     0
      0     1     0     0
      0     0     1     0
      0     0     0     1'''));
    
    input.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    expectedOutput.add(parseMatrix('''-0.100386867815513   0.076681891597503  -0.049082198794982  -0.021689260610181
  -0.279454715225440  -0.269081505356250   0.114433412778961   0.133858687769130
   0.218879650360982   0.073892735462981   0.069073300555062  -0.132069899391626
   0.183633794399577   0.146113141160308  -0.156100829983306  -0.064859465665816'''));
    
    assert(input.length == expectedOutput.length);
    
    for (int i = 0; i < input.length; i++) {
      Dynamic output = input[i].copy();
      output.selfScaleAdjoint(1.0);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestDeterminant() {
    List<Dynamic> input = new List<Dynamic>();
    List<double> expectedOutput = new List<double>();
    input.add(parseMatrix('''0.046171390631154   0.317099480060861   0.381558457093008   0.489764395788231
      0.097131781235848   0.950222048838355   0.765516788149002   0.445586200710899
      0.823457828327293   0.034446080502909   0.795199901137063   0.646313010111265
      0.694828622975817   0.438744359656398   0.186872604554379   0.709364830858073'''));
    expectedOutput.add(-0.199908980087990);
    
    input.add(parseMatrix('''  -2.336158020850647   0.358791716162913   0.571930324052307   0.866477090273158
  -1.190335868711951   1.132044609886021  -0.693048859451418   0.742195189800671
   0.015919048685702   0.552417702663606   1.020805610524362  -1.288062497216858
   3.020318574990609  -1.197139524685751  -0.400475005629390   0.441263145991252'''));
    expectedOutput.add(-5.002276533849802);
    
    input.add(parseMatrix('''0.830828627896291   0.549723608291140
   0.585264091152724   0.917193663829810'''));
    expectedOutput.add(0.440297265243183);
    
    input.add(parseMatrix('''0.285839018820374   0.380445846975357   0.053950118666607
   0.757200229110721   0.567821640725221   0.530797553008973
   0.753729094278495   0.075854289563064   0.779167230102011'''));
    expectedOutput.add(0.022713604103796);
    
    input.add(parseMatrix('''0.934010684229183   0.011902069501241   0.311215042044805   0.262971284540144
   0.129906208473730   0.337122644398882   0.528533135506213   0.654079098476782
   0.568823660872193   0.162182308193243   0.165648729499781   0.689214503140008
   0.469390641058206   0.794284540683907   0.601981941401637   0.748151592823709'''));
    expectedOutput.add(0.117969860982876);
    assert(input.length == expectedOutput.length);
    
    for (int i = 0; i < input.length; i++) {
      double output = input[i].determinant();
      //print('${input[i].cols}x${input[i].rows} = $output');
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestSelfTransposeMultiply() {
    List<Dynamic> inputA = new List<Dynamic>();
    List<Dynamic> inputB = new List<Dynamic>();
    List<Dynamic> expectedOutput = new List<Dynamic>();
    
    inputA.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    inputB.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    expectedOutput.add(parseMatrix('''1.096629343508065   1.170948826011164   0.975285713492989   1.047596917860438
   1.170948826011164   1.987289692246011   1.393079247172284   1.945966332001094
   0.975285713492989   1.393079247172284   1.138698195167051   1.266161729169725
   1.047596917860438   1.945966332001094   1.266161729169725   2.023122749969790'''));
    
    inputA.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
   0.399782649098896   0.431413827463545   0.263802916521990
   0.259870402850654   0.910647594429523   0.145538980384717'''));
    inputB.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    expectedOutput.add(parseMatrix('''0.509665070066463   0.326055864494860   0.326206788210183
   1.011795431418814   1.279272055656899   1.116481872383158
   0.338435097301446   0.262379221330899   0.280398953455993'''));
    
    inputA.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    inputB.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
      0.399782649098896   0.431413827463545   0.263802916521990
      0.259870402850654   0.910647594429523   0.145538980384717'''));
    expectedOutput.add(parseMatrix('''0.509665070066463   1.011795431418814   0.338435097301446
   0.326055864494860   1.279272055656899   0.262379221330899
   0.326206788210183   1.116481872383158   0.280398953455993'''));
    assert(inputA.length == inputB.length);
    assert(inputB.length == expectedOutput.length);
    
    for (int i = 0; i < inputA.length; i++) {
      Dynamic output = inputA[i].copy();
      output.selfTransposeMultiply(inputB[i]);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestSelfMultiply() {
    List<Dynamic> inputA = new List<Dynamic>();
    List<Dynamic> inputB = new List<Dynamic>();
    List<Dynamic> expectedOutput = new List<Dynamic>();
    
    inputA.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    inputB.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    expectedOutput.add(parseMatrix('''0.237893273152584   0.241190507375353   0.115471053480014   0.188086069635435
   0.916103942227480   1.704973929800637   1.164721763902784   1.675285658272358
   0.919182849383279   1.351023203753565   1.053750106199745   1.215382950294249
   1.508657696357159   2.344965008135463   1.450552688877760   2.316940716769603'''));
    
    inputA.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
   0.399782649098896   0.431413827463545   0.263802916521990
   0.259870402850654   0.910647594429523   0.145538980384717'''));
    inputB.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    expectedOutput.add(parseMatrix('''0.812399915745417   0.317522849978516   0.426642592595554
   0.582350288210078   0.507392169174135   0.535489283769338
   0.911348663480233   0.399044409575883   0.555945473748377'''));
    
    inputA.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    inputB.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
      0.399782649098896   0.431413827463545   0.263802916521990
      0.259870402850654   0.910647594429523   0.145538980384717'''));
    expectedOutput.add(parseMatrix('''0.392967349540540   0.912554468305858   0.260331657549835
   0.222551972385485   1.077622741167203   0.247394954900102
   0.523353251675581   1.299202246456530   0.405147467960185'''));
    assert(inputA.length == inputB.length);
    assert(inputB.length == expectedOutput.length);
    
    for (int i = 0; i < inputA.length; i++) {
      Dynamic output = inputA[i].copy();
      output.selfMultiply(inputB[i]);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestSelfMultiplyTranspose() {
    List<Dynamic> inputA = new List<Dynamic>();
    List<Dynamic> inputB = new List<Dynamic>();
    List<Dynamic> expectedOutput = new List<Dynamic>();
    
    inputA.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    inputB.add(parseMatrix('''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
   0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
   0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
   0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
    expectedOutput.add(parseMatrix('''0.232339681975335   0.201799089276976   0.197320406329789   0.642508126615338
   0.201799089276976   1.485449982570056   1.144315170085286   1.998154153033270
   0.197320406329789   1.144315170085286   1.021602397682138   1.557970885061235
   0.642508126615338   1.998154153033270   1.557970885061235   3.506347918663387'''));
    
    inputA.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
   0.399782649098896   0.431413827463545   0.263802916521990
   0.259870402850654   0.910647594429523   0.145538980384717'''));
    inputB.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    expectedOutput.add(parseMatrix('''0.564533756922142   0.253192835205285   0.824764060523193
   0.455715101026938   0.502645707562004   0.735161980594196
   0.626622330821134   0.408983306176468   1.002156614695209'''));
    
    inputA.add(parseMatrix('''0.136068558708664   0.549860201836332   0.622055131485066
   0.869292207640089   0.144954798223727   0.350952380892271
   0.579704587365570   0.853031117721894   0.513249539867053'''));
    inputB.add(parseMatrix('''0.084435845510910   0.800068480224308   0.181847028302852
      0.399782649098896   0.431413827463545   0.263802916521990
      0.259870402850654   0.910647594429523   0.145538980384717'''));
    expectedOutput.add(parseMatrix('''0.564533756922142   0.455715101026938   0.626622330821134
   0.253192835205285   0.502645707562004   0.408983306176468
   0.824764060523193   0.735161980594196   1.002156614695209'''));
    assert(inputA.length == inputB.length);
    assert(inputB.length == expectedOutput.length);
    
    for (int i = 0; i < inputA.length; i++) {
      Dynamic output = inputA[i].copy();
      output.selfMultiplyTranpose(inputB[i]);
      RelativeTest(output, expectedOutput[i]);
    }
  }

  
  void Test() {
    TestDeterminant();
    TestAdjoint();
    TestSelfMultiply();
    TestSelfTransposeMultiply();
    TestSelfMultiplyTranspose();
  }
}
