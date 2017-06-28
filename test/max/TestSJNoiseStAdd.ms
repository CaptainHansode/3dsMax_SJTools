global SJNoiseStrengthAdd

rollout SJNoiseStrengthAdd "" width:180 height:90;
(
    group ""
    (
        button excuteBt "値変更" width:160 hight:20
        spinner addStrength "" range:[-01e+009,01e+009,1] type:#float width:160 align:#center
    )

    on excuteBt pressed do
    (
        for i in selection do
        (
            try (
                noiseStr = i.pos.controller.Noise_Strength;
				noiseStr.x = addStrength.value + noiseStr.x;
				noiseStr.y = addStrength.value + noiseStr.y;
				noiseStr.z = addStrength.value + noiseStr.z;
				i.pos.controller.Noise_Strength = noiseStr;
            ) catch()
            (
                
            )
        )
    )
)
createDialog SJNoiseStrengthAdd style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, #style_resizing, #style_minimizebox)