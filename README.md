# MIMU-Toolbox

## Transfer rate

### Bluetooth

Hard to get streaming up to 1000 Hz when using normal IMU

### USB

Can get 1000 Hz, but the period time will jitter.


Collection of MATLAB functions for reading out IMU data.

## Devices

The new one is MIMU22B96v1, the old is MIMU22BTv2


## Single READOUT is unstable

Does not know if there is a measurement, could all be zero

Then the MIMU continues to output packages, even though stop command is sent


## MPU (Micro Processing Unit)

Should be AT32UC3C2512C. https://www.microchip.com/wwwproducts/en/AT32UC3C2512C#datasheet-toggle



## Algorithms


    IMU_TS_SID // Should be the timestamp?


## Variables

1. `u->f.x` is the specific force, accelerometer reading in x
1. `u->g.x` is the angular velocity.

The IMU readings is stored in the variable `extern int16_t mimu_data[32][10];` where `32` is the number of IMUs. Second position is

    1. imu[0] -> acc.x
    1. imu[1] -> acc.y
    1. imu[2] -> acc.z
    1. imu[3] -> gyro.x
    1. imu[4] -> gyro.y
    1. imu[5] -> gyro.z


## Endianess

The endianess on linux computer is using `lscpu | grep "Byte Order"`

    Byte Order:            Little Endian

But the data comes with Big endian


## Baudrate

To view the current Baudrate

    stty -F /dev/ttyACM0

To change to the maximum allowed in linux (https://github.com/jbkim/Linux-custom-baud-rate)

    stty -F /dev/ttyACM0 460800

Should be fine for 4 IMUs

Isaac claims that Baudrate settings does not matter, it is over USB that has Mbit/s.

## Read rate

If the `BytesAvailableFcnCount` is to low, computer will sink down.


## Sensor

The old one seems to have 2000 Hz and the new one have 1000 hz? Divide the rate
of the old sensor by two, to have equal rates.


## Output data

If even rate output is requested for raw imu data, then IMU time stamp is also included.


## To read out

Need to execute `use_as_normal_imu.m` first, otherwise only zeros will be output.


## Transformation between IMUs

In the MIMU22, IMUs 1 and 3 ,and IMUs 2 and 4 have different transformation matrices.
To rotate to a righthanded coordinate system IMUs 1 and 3 have

    [1 0 0; y_raw = y_platform
    0 -1 0;
    0 0 -1]

Reflection in yz-plane, for some reason.

For imus 2 and 4


    [0 -1 0; y_raw = y_platform
    1 0 0;
    0 0 1]

The above is rotation around z axis 90 deg.

Which is strange. The acc transformation is the same as the gyro transformation, assuming gravity should be measured positively when sensitivity axis points upwards.

This was found from the measurement sequence in `temp_1bin` and `temp_2.bin`.

| Gyro | Acc | Normal IMU | Raw 13 | Raw 24 |
|      | -z  | +z         | +z     | -z     |
| +x   |     | +x         | +x     | -y     |
|      | -y  | +y         | +y     | -x     |
| -x   |     | -x         | -x     |        |
|      | -z  | +z         | +z     |        |
| -y   |     | +y         | y      | -x     |
|      | -x  | -x         | -x     | +y     |
| +y   |     | -y         | -y     | +x     |
|      | -z  | +z         |        |        |
| -z   |     | +z         | +z     | -z     |
|      | -z  | +z         | +z     |        |
| +z   |     | -z         | -z     | +z     |
|      |     |            |        |        |

The two left columns follow the coordinate system on the casing of the new array IMU.

## Order of execution

1. Execute `use_as_normal_imu.m` from OpenShoe repo. Must be done to activate
the device, dont know the reason.

2. Open the devices with `open_device_0.m` and `open_device_1.m`, that
put `com0` and `com` in workspace.

3. Execute

4. Extract the data from the binary files:

        data1 = get_data_binary_file('temp_1.bin');
        data2 = get_data_binary_file('temp_2.bin');

5. Parse the data with:

## Rate Divider

| Divider | Rate (Hz) |
| 1       | 1000      |
| 2       | 500       |
| 3       | 250       |
| 4       | 125       |
| 5       | 62.5      |
| 6       | 31.25     |
| 7       | 15.625    |
