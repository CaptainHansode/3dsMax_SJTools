unRegisterTimeCallback RunMorpheusSliderUpdate;
--TODO:なぜかunRegisterだと破棄されない、なので空の関数でごまかす
function MorpheusSliderUpdate = ()
function RunMorpheusSliderUpdate = MorpheusSliderUpdate();
registerTimeCallback RunMorpheusSliderUpdate;
gc();
