function setStdMat obj = (
	meditMaterials[1] = Standardmaterial ();
	--sceneMaterials[1].selfIllumAmount = 50;
	meditMaterials[1].selfIllumAmount = 50;
	obj.material = meditMaterials[1];
)

setStdMat $


function setEff = (
	addEffect (Motion_Blur ())
		--getEffect 1
)

setEff();

function setRender = (
	rendSaveFile = true;
	rendOutputFilename = "T:\\";
	rendOutputFilename = "C:\\test.bmp";
)