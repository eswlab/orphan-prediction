#!/bin/bash
sed -i 's/braker_S/Brake-small/g' orphans_upsetR-main2.csv
sed -i 's/braker_X/Brake-large/g' orphans_upsetR-main2.csv
sed -i 's/maker_C5/Make-pool+trans/g' orphans_upsetR-main2.csv
sed -i 's/maker_C6/Make-small+trans/g' orphans_upsetR-main2.csv
sed -i 's/trans_mikado-38/DirInf-orph/g' orphans_upsetR-main2.csv
sed -i 's/trans_po/DirInf-pool/g' orphans_upsetR-main2.csv
sed -i 's/braker-mikado_both38/BIND-orph/g' orphans_upsetR-main2.csv
sed -i 's/maker-mikado_both38/MIND-orph/g' orphans_upsetR-main2.csv
