#!/bin/bash

# create dev predictions for every pool model
#
for encnum in `cat dev_ids.lst`

do

  for model in `cut -f2 sorted_train_ids.dat`

  do
    echo "EncNum $encnum, Model $model"

    mkdir -p "data/data_$encnum/"

    # enable continue when stopped
    if [ ! -f "data/data_$encnum/generated_$model.dat" ]; then
      #cp -a data/data_empty/* "data/data_$encnum/"
      #grep "^$encnum" train.dat > "data/data_$encnum/train.dat"

      python sepens/predict_ts.py --cuda --data "data/data_$model" \
                           --checkpoint "models/model_$model.pt" \
                           --outf "data/data_$encnum/generated_$model.dat"

      paste <(cut -f1-4 "data/data_$model/dev.dat") \
            "data/data_$encnum/generated_$model.dat" \
            > "data/data_$encnum/label_pred.dat"
    fi

  done

done

