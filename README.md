# SKR3SermoonD1Klipper
Klipper settings for BTT SKR3 build into the Creality Sermoon D1

This is WIP, do not use it yet.
I will add details here when it is ready and works.

# Progress

## Mechanics
Created an adapter to mount the SKR 3 since it does not fit to the mounting holes. Later I added some mounts for a big 120mm fan (because it was easier with a fan larger than the board). The fan runs with about 600 rmp and is barly audible.

Since I plan to add an extra stepper for a auxilary feeder, some space for the BTT Exp board was neccessary (now we are at 3 flavours).

| No fan | 120mm fan | 120mm fan + ext board |
| :----: | :----: | :----: |
| <img src="SKR3-Adapter/PNG/SKR3-Adapter.png" width="80%" height="80%"> | <img src="SKR3-Adapter/PNG/SKR3-Adapter-withFan.png" width="80%" height="80%"> | <img src="SKR3-Adapter/PNG/SKR3-Adapter-withFan-withExpBoard.png" width="80%" height="80%">

Note: You either need to cut a hole onto the bottom sheet or replace it with some new and larger feet (my plan).

Note2: The original mainboard fan does not transport much air, but makes quite some noise. So a slow turning 120mm fan is much better.
The next source of noise is the fan in the power supply. I replaced that fan with a low noise 120mm fan. Now it is barly audible.

Note3: We need heigher feet. Already printed some test feet with 28mm height (need 40mm screws - probably will increase by 5mm when I have that screws available).

Note4: I cannot check whether the original wires are long enough since I did buy the printer used and the wires are not original anymore.
## Klipper
Installed MainsaleOS on a RPi, created the firmware and flashed.
X and Y axis work including the limit switches.

CR Touch is working fine.
Even the Z-Tild option works very nice.
Z Axis is silent (one reason I did all this, the original drivers for Z are very noisy).

X and Y axis have some resonances when they move fast. Turning stealthchop on reduced the resonances a lot.

Extruder works and is calibrated.

Bed mesh works (I am not happy with my bed yet).

A test with an LED RGB ring was succesful.

Note: I had issues with the Z axes (suddenly lots of noise, intermediatly running in wrong direction). To hunt this I added an extra SKR 3 E3 mini board for the Z Axes (Klipper is so flexible).

At the end it turned out that the (new) cables to the steppers are faulty and provided not always a good contact. After replacing these, all was fine.

Now I am back to the SKR 3 only.

