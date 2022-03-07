game = {}
dataName = "CLIENTDATAv2.lua"

local defaultGamepad

ext_data = {}

ext_data.flashDB = {
	["space fractal"] = {0.459, 0.859, 1.019, 1.199, 1.579, 1.919, 2.099, 2.259, 2.599, 2.959, 3.319, 3.719, 3.899, 4.039, 4.439, 4.779, 4.959, 5.099, 5.459, 5.839, 6.199, 6.559, 6.719, 6.879, 7.279, 7.639, 7.819, 7.959, 8.359, 8.679, 9.039, 9.399, 9.599, 9.759, 10.139, 10.479, 10.659, 10.799, 11.199, 11.559, 11.899, 12.259, 12.459, 12.639, 12.999, 13.339, 13.499, 13.659, 14.039, 14.379, 14.719, 15.059, 15.259, 15.439, 15.859, 16.159, 16.299, 16.519, 16.899, 17.239, 17.579, 17.959, 18.159, 18.279, 18.699, 19.058, 19.238, 19.378, 19.758, 20.078, 20.458, 20.838, 20.998, 21.158, 21.538, 21.938, 22.058, 22.238, 22.618, 22.958, 23.298, 23.638, 24.018, 24.358, 24.718, 24.878, 24.998, 25.078, 25.418, 25.798, 26.158, 26.518, 26.878, 27.258, 27.578, 27.798, 27.878, 27.958, 28.298, 28.658, 29.018, 29.358, 29.758, 30.118, 30.458, 30.658, 30.758, 30.818, 31.158, 31.498, 31.878, 32.258, 32.618, 32.958, 33.278, 33.518, 33.618, 33.698, 34.038, 34.358, 34.738, 35.078, 35.458, 35.798, 36.138, 36.338, 36.438, 36.498, 36.858, 37.198, 37.557, 37.957, 38.317, 38.657, 38.997, 39.177, 39.277, 39.357, 39.717, 40.097, 40.457, 40.797, 41.157, 41.517, 41.817, 42.057, 42.157, 42.217, 42.597, 42.937, 43.297, 43.657, 44.017, 44.357, 44.717, 44.917, 45.037, 45.097, 45.457, 45.817, 46.177, 47.257, 47.597, 48.677, 50.097, 50.437, 51.557, 52.937, 53.337, 54.357, 55.837, 56.157, 57.256, 58.356, 58.676, 59.056, 60.136, 61.156, 61.556, 62.956, 64.256, 64.376, 65.856, 67.236, 67.976, 68.696, 69.056, 69.396, 69.756, 70.116, 70.456, 70.656, 70.736, 70.836, 71.156, 71.516, 71.896, 72.256, 72.596, 72.956, 73.296, 73.496, 73.576, 73.656, 73.996, 74.356, 74.716, 75.095, 75.455, 75.795, 76.135, 76.355, 76.455, 76.495, 76.855, 77.215, 77.575, 77.935, 78.275, 78.655, 78.975, 79.155, 79.255, 79.335, 79.695, 80.055, 80.435, 80.815, 81.195, 81.535, 81.855, 82.055, 82.155, 82.215, 82.555, 82.935, 83.275, 83.635, 84.015, 84.375, 84.715, 84.915, 85.035, 85.095, 85.435, 85.795, 86.155, 86.535, 86.895, 87.235, 87.575, 87.755, 87.855, 87.935, 88.255, 88.655, 88.995, 89.375, 89.755, 90.095, 90.455, 90.655, 90.755, 90.835, 91.155, 91.515, 91.935, 92.235, 92.595, 92.975, 93.295, 93.675, 94.054, 94.414, 94.754, 95.114, 95.454, 95.834, 96.154, 96.554, 96.914, 97.274, 97.614, 97.954, 98.314, 98.674, 99.054, 99.414, 99.754, 100.094, 100.454, 100.794, 101.154, 101.534, 101.894, 102.254, 102.594, 102.954, 103.334, 103.674, 104.014, 104.374, 104.734, 105.074, 105.454, 105.774, 106.154, 106.534, 106.894, 107.234, 107.594, 107.954, 108.294, 108.654, 109.034, 109.374, 109.734, 110.074, 110.454, 110.794, 111.154, 111.534, 111.894, 112.254, 112.594, 112.953, 113.313, 113.653, 114.013, 114.393, 114.753, 115.133, 115.513, 115.853, 117.213, 118.673, 120.053, 121.533, 122.953, 124.373, 125.793, 127.233, 128.653, 130.093, 131.552, 132.972, 134.392, 135.832, 140.092, 140.472, 140.832, 141.172, 141.552, 141.872, 142.072, 142.172, 142.252, 142.572, 142.912, 143.292, 143.652, 144.032, 144.392, 144.752, 144.952, 145.032, 145.092, 145.452, 145.832, 146.172, 146.552, 146.892, 147.252, 147.572, 147.772, 147.872, 147.952, 148.292, 148.672, 149.032, 149.392, 149.752, 150.092, 150.451, 150.651, 150.731, 150.831, 151.151, 151.531, 151.891, 152.271, 152.631, 152.971, 153.331, 153.531, 153.631, 153.691, 154.051, 154.391, 154.751, 155.091, 155.451, 155.811, 156.151, 156.351, 156.451, 156.531, 156.871, 157.231, 157.591, 157.951, 158.331, 158.671, 158.991, 159.171, 159.271, 159.351, 159.711, 160.051, 160.411, 160.791, 161.151, 161.491, 161.851, 162.051, 162.151, 162.211, 162.611, 162.951, 163.351, 163.671, 164.391, 164.751, 165.091, 165.791, 166.151, 166.551, 167.271, 167.651, 167.951, 168.671, 169.050, 169.370, 170.110, 170.450, 170.790, 171.530, 171.870, 172.250, 172.970, 173.310, 173.690, 174.450, 174.750, 175.110, 175.830, 176.170, 176.550, 177.210, 177.590, 177.950, 178.670, 179.050, 179.370, 180.130, 180.450, 180.830, 181.550, 181.910, 182.250, 182.950, 183.290, 183.650, 184.030, 184.390, 184.750, 185.130, 185.470, 185.830},
	["planet bass"] = {1.159, 4.559, 5.079, 5.359, 6.339, 7.039, 7.279, 7.759, 8.219, 8.959, 9.179, 10.159, 10.819, 11.099, 11.579, 12.079, 12.759, 13.019, 13.959, 14.619, 14.879, 15.899, 16.619, 16.859, 17.799, 18.519, 18.759, 19.238, 19.738, 20.438, 20.678, 21.598, 22.318, 22.578, 23.538, 24.238, 24.458, 25.458, 25.958, 26.358, 26.838, 27.198, 27.858, 28.338, 28.838, 29.318, 29.798, 30.258, 30.758, 31.038, 31.258, 31.698, 32.158, 32.658, 33.158, 33.638, 34.118, 34.578, 35.058, 35.578, 36.038, 36.498, 37.018, 37.498, 37.977, 38.457, 38.697, 38.917, 39.397, 39.877, 40.357, 40.837, 41.317, 41.797, 42.297, 42.557, 42.777, 43.257, 43.757, 44.217, 44.697, 45.157, 45.637, 46.137, 46.357, 46.577, 47.057, 47.557, 48.057, 48.517, 49.017, 49.457, 49.957, 50.437, 50.917, 51.397, 51.857, 52.337, 52.837, 53.317, 53.777, 54.037, 54.257, 54.777, 55.257, 55.697, 56.157, 56.656, 57.156, 57.656, 57.896, 58.536, 59.076, 59.556, 59.776, 60.476, 60.976, 61.496, 61.756, 62.436, 62.916, 63.416, 63.896, 64.376, 64.856, 65.296, 65.536, 66.256, 66.756, 67.256, 67.496, 68.176, 68.656, 69.156, 69.416, 70.116, 70.596, 71.096, 71.556, 72.016, 72.496, 72.976, 73.456, 73.956, 74.436, 74.916, 75.115, 75.815, 76.335, 76.835, 77.055, 77.715, 78.235, 78.755, 79.235, 79.695, 80.175, 80.635, 81.155, 81.595, 82.055, 82.555, 83.055, 83.535, 84.035, 84.535, 84.995, 85.255, 85.515, 86.015, 86.475, 86.955, 87.175, 87.395, 87.915, 88.375, 88.875, 89.095, 89.315, 89.815, 90.315, 90.755, 90.955, 91.195, 91.735, 92.195, 92.695, 92.915, 93.155, 93.655, 94.114, 94.594, 94.834, 95.034, 95.554, 96.054, 96.514, 96.754, 96.974, 97.454, 97.954, 98.394, 98.594, 98.854, 99.354, 99.854, 100.314, 100.534, 100.794, 101.294, 101.754, 102.254, 102.494, 102.754, 103.234, 103.694, 104.194, 104.434, 104.634, 105.074, 105.554, 106.074, 106.574, 107.054, 107.554, 108.034, 108.514, 108.994, 109.474, 109.954, 110.434, 110.914, 111.394, 111.894, 112.374, 112.853, 113.293, 113.793, 114.293, 114.793, 115.253, 115.733, 116.173, 116.673, 117.173, 117.633, 118.093, 118.633, 119.073, 119.573, 120.053, 120.513, 121.013, 121.473, 121.973, 122.453, 122.933, 123.413, 123.893, 124.353, 124.853, 125.313, 125.813, 126.273, 126.753, 127.233, 127.673, 128.133, 128.633, 129.113, 129.573, 130.053, 130.533, 131.013, 131.512, 131.992, 132.472, 132.972, 133.472, 133.952, 134.432, 134.912, 135.392, 135.872, 136.392, 136.832, 137.292, 137.772, 138.272, 138.752, 139.232, 139.732, 140.252, 140.712, 141.192, 141.632, 142.132, 142.572, 143.092, 143.572, 144.032, 144.532, 145.012, 145.512, 145.972, 146.412, 146.952, 147.372, 147.852, 148.372, 148.832, 149.292, 149.772, 150.271, 150.751, 151.231, 151.691, 152.171, 152.651, 153.111, 153.591, 154.091, 154.571, 155.031, 155.531, 156.011, 156.491, 156.951, 157.431, 157.911, 158.391, 158.851, 159.391, 159.871, 160.331, 160.811, 161.291, 161.771, 162.271, 162.731, 163.231, 163.731, 164.231, 164.691, 165.171, 165.671, 165.911, 166.151, 166.611, 167.111, 167.571, 168.071, 168.531, 169.010, 169.490, 169.970, 170.470, 170.910, 171.430, 171.910, 172.390, 172.870, 173.370, 173.590, 173.790, 174.310, 174.790, 175.270, 175.750, 176.230, 176.710, 177.170, 177.670, 178.150, 178.630, 179.090, 179.590, 180.050, 180.550, 181.030, 181.270, 181.490, 181.970, 182.450, 182.910, 183.370, 183.850, 184.330, 184.830, 185.310, 185.790, 186.290, 186.770, 187.250, 187.75, 188.229, 188.689, 188.889, 189.149, 189.629, 190.129, 190.609, 191.109, 191.569, 192.029, 192.489, 192.809, 193.409, 193.969, 194.449, 194.669, 195.309, 195.869, 196.369, 196.589, 197.269, 197.789, 198.289, 198.769, 199.249, 199.729, 200.189, 200.409, 201.149, 201.649, 202.109, 202.349, 203.009, 203.569, 204.069, 204.309, 204.949, 205.449, 205.949, 206.449, 206.889, 207.368, 207.828, 208.208, 208.808, 209.328, 209.828, 210.068, 210.688, 211.188, 211.728, 211.988, 212.628, 213.148, 213.628, 214.108, 214.568, 215.068, 215.548, 216.048, 216.528, 217.008, 217.468, 217.968, 218.428, 218.888, 219.388, 219.608, 219.888},
	["fireflies"] = {3.495, 3.995, 4.828, 6.161, 6.661, 8.828, 9.328, 10.161, 11.495, 11.995, 14.161, 14.661, 15.495, 16.828, 17.328, 18.161, 19.495, 19.995, 20.828, 22.161, 22.661, 24.828, 25.328, 26.495, 27.495, 27.995, 28.661, 29.161, 29.995, 30.161, 30.661, 31.828, 32.828, 33.328, 33.995, 34.328, 34.495, 35.161, 35.495, 35.995, 37.161, 37.995, 38.661, 39.495, 40.828, 41.328, 42.495, 43.495, 45.328, 45.828, 46.828, 48.161, 49.495, 50.828, 52.161, 53.328, 54.828, 56.161, 57.328, 58.828, 59.995, 61.495, 62.828, 64.161, 65.495, 66.828, 67.495, 67.995, 69.161, 70.161, 70.661, 71.328, 71.828, 72.661, 72.828, 73.328, 74.495, 75.495, 75.995, 76.661, 76.995, 77.161, 77.828, 78.161, 78.661, 79.828, 80.661, 81.328, 81.995, 82.495, 83.328, 83.495, 83.995, 85.161, 86.161, 86.828, 87.495, 88.161, 88.828, 89.495, 90.161, 90.828, 91.495, 92.161, 92.828, 92.995, 93.161, 93.495, 94.161, 94.828, 95.495, 96.161, 96.828, 96.995, 97.161, 97.495, 97.828, 97.995, 98.161, 98.328, 98.495, 98.661, 99.161, 99.495, 100.161, 100.828, 101.495, 102.161, 102.328, 102.495, 102.828, 103.161, 103.495, 104.161, 104.828, 104.995, 105.161, 105.495, 106.161, 106.828, 107.495, 107.661, 107.828, 108.161, 108.828, 109.495, 110.161, 110.828, 111.495, 112.161, 112.828, 113.328, 114.495, 115.495, 115.995, 116.661, 117.328, 117.828, 117.995, 118.661, 119.828, 120.328, 120.828, 121.328, 121.995, 122.328, 122.495, 123.161, 123.495, 123.995, 125.161, 126.161, 126.661, 127.828, 128.661, 128.828, 129.328, 130.495, 131.495, 133.328, 133.661, 133.828, 134.161, 134.661, 135.161, 135.495, 135.995, 136.495, 136.661, 137.328, 137.828, 138.161, 138.495, 139.161, 139.495, 139.995, 140.495, 140.828, 141.328, 141.828, 142.161, 142.661, 143.161, 143.495, 143.995, 144.495, 144.828, 145.328, 145.828, 146.161, 146.661, 147.161, 147.495, 147.995, 148.495, 148.828, 149.328, 149.828, 150.161, 150.661, 151.161, 151.495, 151.995, 152.495, 152.828, 153.328, 153.828, 154.161, 154.661, 155.161, 155.495, 156.161, 156.828, 156.995, 157.161, 157.495, 158.161, 158.828, 159.161, 159.328, 159.495, 159.661, 159.828, 160.161, 160.828, 161.495, 161.828, 161.995, 162.161, 162.495, 162.828, 163.495, 164.161, 164.495, 164.661, 164.995, 165.161, 165.495, 166.161, 166.828, 167.161, 167.328, 167.828, 168.161, 168.828, 169.161, 169.328, 169.495, 169.828, 170.161, 170.828, 171.495, 172.161, 172.495, 172.661, 172.828, 173.495, 174.161, 174.828, 175.161, 175.328, 175.661, 175.828, 176.161, 176.828, 177.495, 177.828, 177.995, 178.161, 178.828, 179.495, 180.161, 180.495, 180.661, 180.995, 181.161, 181.495, 182.161, 182.828, 182.995, 183.161, 183.495, 183.828, 184.161, 184.828, 185.495, 185.828, 185.995, 186.328, 186.495, 186.828, 187.495, 188.161, 188.495, 188.661, 188.828, 189.161, 189.495, 190.161, 190.328, 190.495, 190.661, 190.828, 191.161, 191.495, 191.828, 192.161, 192.828, 193.495, 194.161, 194.828, 195.495, 196.161, 196.828, 196.995, 197.161, 197.495, 198.161, 198.995, 199.495, 200.828, 203.661, 204.828, 206.161, 207.495, 208.828, 210.161, 211.495, 212.161, 212.661, 214.161, 215.495, 216.828},
}

ext_data.beatmap = {
	["space fractal"] = {0.35714285714, 0.71428571428, 1.07142857142, 1.42857142856, 1.7857142857, 2.14285714284, 2.49999999998, 2.85714285712, 3.21428571426, 3.5714285714, 3.92857142854, 4.28571428568, 4.64285714282, 4.99999999996, 5.3571428571, 5.71428571424, 6.07142857138, 6.42857142852, 6.78571428566, 7.1428571428, 7.49999999994, 7.85714285708, 8.21428571422, 8.57142857136, 8.9285714285, 9.28571428564, 9.64285714278, 9.99999999992, 10.35714285706, 10.7142857142, 11.07142857134, 11.42857142848, 11.78571428562, 12.14285714276, 12.4999999999, 12.85714285704, 13.21428571418, 13.57142857132, 13.92857142846, 14.2857142856, 14.64285714274, 14.99999999988, 15.35714285702, 15.71428571416, 16.0714285713, 16.42857142844, 16.78571428558, 17.14285714272, 17.49999999986, 17.857142857, 18.21428571414, 18.57142857128, 18.92857142842, 19.28571428556, 19.6428571427, 19.99999999984, 20.35714285698, 20.71428571412, 21.07142857126, 21.4285714284, 21.78571428554, 22.14285714268, 22.49999999982, 22.85714285696, 23.2142857141, 23.57142857124, 23.92857142838, 24.28571428552, 24.64285714266, 24.9999999998, 25.35714285694, 25.71428571408, 26.07142857122, 26.42857142836, 26.7857142855, 27.14285714264, 27.49999999978, 27.85714285692, 28.21428571406, 28.5714285712, 28.92857142834, 29.28571428548, 29.64285714262, 29.99999999976, 30.3571428569, 30.71428571404, 31.07142857118, 31.42857142832, 31.78571428546, 32.1428571426, 32.49999999974, 32.85714285688, 33.21428571402, 33.57142857116, 33.9285714283, 34.28571428544, 34.64285714258, 34.99999999972, 35.35714285686, 35.714285714, 36.07142857114, 36.42857142828, 36.78571428542, 37.14285714256, 37.4999999997, 37.85714285684, 38.21428571398, 38.57142857112, 38.92857142826, 39.2857142854, 39.64285714254, 39.99999999968, 40.35714285682, 40.71428571396, 41.0714285711, 41.42857142824, 41.78571428538, 42.14285714252, 42.49999999966, 42.8571428568, 43.21428571394, 43.57142857108, 43.92857142822, 44.28571428536, 44.6428571425, 44.99999999964, 45.35714285678, 45.71428571392, 46.07142857106, 46.4285714282, 46.78571428534, 47.14285714248, 47.49999999962, 47.85714285676, 48.2142857139, 48.57142857104, 48.92857142818, 49.28571428532, 49.64285714246, 49.9999999996, 50.35714285674, 50.71428571388, 51.07142857102, 51.42857142816, 51.7857142853, 52.14285714244, 52.49999999958, 52.85714285672, 53.21428571386, 53.571428571, 53.92857142814, 54.28571428528, 54.64285714242, 54.99999999956, 55.3571428567, 55.71428571384, 56.07142857098, 56.42857142812, 56.78571428526, 57.1428571424, 57.49999999954, 57.85714285668, 58.21428571382, 58.57142857096, 58.9285714281, 59.28571428524, 59.64285714238, 59.99999999952, 60.35714285666, 60.7142857138, 61.07142857094, 61.42857142808, 61.78571428522, 62.14285714236, 62.4999999995, 62.85714285664, 63.21428571378, 63.57142857092, 63.92857142806, 64.2857142852, 64.64285714234, 64.99999999948, 65.35714285662, 65.71428571376, 66.0714285709, 66.42857142804, 66.78571428518, 67.14285714232, 67.49999999946, 67.8571428566, 68.21428571374, 68.57142857088, 68.92857142802, 69.28571428516, 69.6428571423, 69.99999999944, 70.35714285658, 70.71428571372, 71.07142857086, 71.428571428, 71.78571428514, 72.14285714228, 72.49999999942, 72.85714285656, 73.2142857137, 73.57142857084, 73.92857142798, 74.28571428512, 74.64285714226, 74.9999999994, 75.35714285654, 75.71428571368, 76.07142857082, 76.42857142796, 76.7857142851, 77.14285714224, 77.49999999938, 77.85714285652, 78.21428571366, 78.5714285708, 78.92857142794, 79.28571428508, 79.64285714222, 79.99999999936, 80.3571428565, 80.71428571364, 81.07142857078, 81.42857142792, 81.78571428506, 82.1428571422, 82.49999999934, 82.85714285648, 83.21428571362, 83.57142857076, 83.9285714279, 84.28571428504, 84.64285714218, 84.99999999932, 85.35714285646, 85.7142857136, 86.07142857074, 86.42857142788, 86.78571428502, 87.14285714216, 87.4999999993, 87.85714285644, 88.21428571358, 88.57142857072, 88.92857142786, 89.285714285, 89.64285714214, 89.99999999928, 90.35714285642, 90.71428571356, 91.0714285707, 91.42857142784, 91.78571428498, 92.14285714212, 92.49999999926, 92.8571428564, 93.21428571354, 93.57142857068, 93.92857142782, 94.28571428496, 94.6428571421, 94.99999999924, 95.35714285638, 95.71428571352, 96.07142857066, 96.4285714278, 96.78571428494, 97.14285714208, 97.49999999922, 97.85714285636, 98.2142857135, 98.57142857064, 98.92857142778, 99.28571428492, 99.64285714206, 99.9999999992, 100.35714285634, 100.71428571348, 101.07142857062, 101.42857142776, 101.7857142849, 102.14285714204, 102.49999999918, 102.85714285632, 103.21428571346, 103.5714285706, 103.92857142774, 104.28571428488, 104.64285714202, 104.99999999916, 105.3571428563, 105.71428571344, 106.07142857058, 106.42857142772, 106.78571428486, 107.142857142, 107.49999999914, 107.85714285628, 108.21428571342, 108.57142857056, 108.9285714277, 109.28571428484, 109.64285714198, 109.99999999912, 110.35714285626, 110.7142857134, 111.07142857054, 111.42857142768, 111.78571428482, 112.14285714196, 112.4999999991, 112.85714285624, 113.21428571338, 113.57142857052, 113.92857142766, 114.2857142848, 114.64285714194, 114.99999999908, 115.35714285622, 115.71428571336, 116.0714285705, 116.42857142764, 116.78571428478, 117.14285714192, 117.49999999906, 117.8571428562, 118.21428571334, 118.57142857048, 118.92857142762, 119.28571428476, 119.6428571419, 119.99999999904, 120.35714285618, 120.71428571332, 121.07142857046, 121.4285714276, 121.78571428474, 122.14285714188, 122.49999999902, 122.85714285616, 123.2142857133, 123.57142857044, 123.92857142758, 124.28571428472, 124.64285714186, 124.999999999, 125.35714285614, 125.71428571328, 126.07142857042, 126.42857142756, 126.7857142847, 127.14285714184, 127.49999999898, 127.85714285612, 128.21428571326, 128.5714285704, 128.92857142754, 129.28571428468, 129.64285714182, 129.99999999896, 130.3571428561, 130.71428571324, 131.07142857038, 131.42857142752, 131.78571428466, 132.1428571418, 132.49999999894, 132.85714285608, 133.21428571322, 133.57142857036, 133.9285714275, 134.28571428464, 134.64285714178, 134.99999999892, 135.35714285606, 135.7142857132, 136.07142857034, 136.42857142748, 136.78571428462, 137.14285714176, 137.4999999989, 137.85714285604, 138.21428571318, 138.57142857032, 138.92857142746, 139.2857142846, 139.64285714174, 139.99999999888, 140.35714285602, 140.71428571316, 141.0714285703, 141.42857142744, 141.78571428458, 142.14285714172, 142.49999999886, 142.857142856, 143.21428571314, 143.57142857028, 143.92857142742, 144.28571428456, 144.6428571417, 144.99999999884, 145.35714285598, 145.71428571312, 146.07142857026, 146.4285714274, 146.78571428454, 147.14285714168, 147.49999999882, 147.85714285596, 148.2142857131, 148.57142857024, 148.92857142738, 149.28571428452, 149.64285714166, 149.9999999988, 150.35714285594, 150.71428571308, 151.07142857022, 151.42857142736, 151.7857142845, 152.14285714164, 152.49999999878, 152.85714285592, 153.21428571306, 153.5714285702, 153.92857142734, 154.28571428448, 154.64285714162, 154.99999999876, 155.3571428559, 155.71428571304, 156.07142857018, 156.42857142732, 156.78571428446, 157.1428571416, 157.49999999874, 157.85714285588, 158.21428571302, 158.57142857016, 158.9285714273, 159.28571428444, 159.64285714158, 159.99999999872, 160.35714285586, 160.714285713, 161.07142857014, 161.42857142728, 161.78571428442, 162.14285714156, 162.4999999987, 162.85714285584, 163.21428571298, 163.57142857012, 163.92857142726, 164.2857142844, 164.64285714154, 164.99999999868, 165.35714285582, 165.71428571296, 166.0714285701, 166.42857142724, 166.78571428438, 167.14285714152, 167.49999999866, 167.8571428558, 168.21428571294, 168.57142857008, 168.92857142722},
	["welcome to my mind"] = {1.779, 2.419, 3.039, 3.619, 4.299, 4.879, 5.499, 6.079, 6.679, 7.299, 7.939, 8.599, 9.179, 9.779, 10.379, 11.039, 11.679, 12.239, 12.919, 13.539, 14.479, 14.799, 15.119, 15.739, 16.059, 16.359, 16.919, 17.259, 17.579, 18.199, 18.499, 18.818, 19.398, 19.758, 20.058, 20.658, 20.998, 21.298, 21.898, 22.238, 22.558, 23.178, 23.498, 23.798, 24.418, 25.078, 25.698, 26.298, 26.938, 27.538, 28.158, 28.758, 29.638, 29.998, 30.318, 30.638, 30.958, 31.298, 31.878, 32.198, 32.498, 32.798, 33.098, 33.418, 33.718, 34.338, 34.978, 35.578, 36.198, 36.838, 37.478, 38.077, 38.717, 39.377, 39.997, 40.597, 41.217, 41.877, 42.497, 43.097, 43.717, 44.377, 44.697, 44.997, 45.637, 45.957, 46.237, 46.857, 47.157, 47.457, 48.157, 48.497, 48.797, 49.417, 49.717, 50.017, 50.697, 50.997, 51.317, 51.957, 52.257, 52.577, 53.197, 53.517, 53.837, 54.497, 55.097, 55.777, 56.376, 56.996, 57.636, 58.236, 58.836, 59.476, 59.796, 60.116, 60.416, 60.736, 61.056, 61.356, 61.996, 62.336, 62.636, 62.956, 63.276, 63.576, 63.896, 64.516, 65.156, 65.796, 66.396, 67.016, 67.696, 68.276, 68.876, 69.496, 70.156, 70.776, 71.396, 72.036, 72.596, 73.236, 73.876, 74.216, 74.476, 74.796, 75.115, 75.455, 75.775, 76.095, 76.435, 76.715, 77.055, 77.375, 77.695, 78.015, 78.335, 78.655, 78.975, 79.295, 79.595, 79.895, 80.195, 80.535, 80.855, 81.175, 81.495, 81.815, 82.135, 82.455, 82.755, 83.075, 83.395, 83.715, 84.015, 84.375},
	["planet bass"] = {4.439, 8.259, 12.119, 15.879, 19.718, 23.538, 27.278, 31.218, 35.558, 38.957, 43.277, 46.597, 50.957, 54.257, 57.816, 59.816, 61.756, 65.556, 67.536, 69.396, 73.236, 75.175, 77.075, 81.195, 82.635, 85.035, 88.895, 92.715, 96.534, 100.394, 108.974, 111.894, 113.773, 115.693, 116.213, 120.053, 123.913, 127.713, 131.592, 135.432, 139.272, 143.112, 146.952, 150.771, 154.591, 158.431, 162.291, 162.751, 166.111, 170.470, 173.810, 178.130, 181.470, 185.810, 189.189, 192.929, 194.689, 196.589, 200.409, 202.389, 204.309, 208.108, 210.028, 211.928, 216.048, 217.488, 219.888},
	["planet bass expert"] = {4.359, 5.019, 5.219, 6.189, 6.939, 7.179, 8.159, 8.849, 9.089, 10.039, 10.779, 10.979, 11.949, 12.659, 12.919, 13.879, 14.599, 14.799, 15.819, 16.499, 16.739, 17.689, 18.419, 18.659, 19.678, 20.338, 20.578, 21.528, 22.278, 22.498, 23.478, 24.198, 24.438, 25.378, 25.878, 26.358, 26.818, 27.178, 27.778, 28.278, 28.758, 29.218, 29.698, 30.178, 30.658, 31.658, 32.598, 33.578, 34.498, 35.498, 35.978, 36.418, 36.878, 37.378, 37.877, 38.317, 39.317, 40.257, 41.237, 42.187, 43.177, 43.657, 44.097, 44.577, 45.037, 45.537, 46.017, 46.997, 47.977, 48.917, 49.897, 50.847, 51.337, 51.777, 52.297, 52.777, 53.217, 53.697, 54.677, 55.657, 56.596, 57.576, 57.776, 58.476, 59.476, 59.736, 60.456, 61.416, 61.636, 62.376, 63.276, 64.256, 65.256, 65.476, 66.216, 67.176, 67.416, 68.096, 69.076, 69.316, 70.046, 71.016, 71.956, 72.936, 73.176, 73.876, 74.836, 75.775, 76.775, 77.015, 77.755, 78.675, 79.635, 80.595, 81.075, 82.035, 82.515, 83.475, 84.435, 84.935, 85.655, 85.895, 86.835, 87.555, 87.785, 88.755, 89.475, 89.695, 90.675, 91.375, 91.655, 92.605, 93.335, 93.575, 94.514, 95.244, 95.474, 96.434, 97.174, 97.414, 98.314, 99.044, 99.304, 100.404, 101.014, 101.234, 102.194, 102.894, 103.154, 104.154, 104.854, 105.074, 106.014, 106.514, 106.974, 107.454, 108.434, 108.914, 109.374, 109.874, 110.354, 110.834, 111.294, 111.774, 112.274, 112.753, 113.213, 113.693, 114.173, 114.653, 115.113, 115.613, 116.133, 117.093, 118.013, 118.973, 119.473, 119.953, 120.933, 121.873, 122.853, 123.293, 123.813, 124.773, 126.193, 127.153, 127.613, 128.073, 129.053, 130.013, 130.973, 131.452, 131.902, 132.872, 133.852, 134.792, 135.292, 135.812, 136.752, 137.712, 138.672, 139.172, 139.632, 140.592, 141.552, 142.512, 142.972, 143.472, 144.422, 145.372, 146.372, 146.852, 147.292, 148.272, 149.232, 150.191, 150.671, 151.151, 152.111, 153.071, 154.051, 154.511, 154.991, 155.911, 156.891, 157.871, 158.331, 158.831, 159.791, 160.761, 161.731, 162.661, 163.131, 163.611, 164.111, 164.591, 165.071, 165.551, 166.491, 167.511, 168.451, 169.410, 170.350, 170.820, 171.310, 171.790, 172.290, 172.750, 173.190, 174.170, 175.170, 176.110, 177.070, 178.040, 178.510, 178.970, 179.470, 179.950, 180.410, 180.890, 181.870, 182.840, 183.790, 184.770, 185.710, 186.170, 186.690, 187.170, 187.630, 188.11, 188.569, 189.549, 190.509, 191.459, 192.449, 192.669, 193.409, 194.369, 194.589, 195.319, 196.269, 196.509, 197.249, 198.169, 199.169, 200.129, 200.349, 201.069, 202.019, 202.289, 202.989, 203.989, 204.209, 204.929, 205.889, 206.849, 207.808, 208.028, 208.758, 209.768, 209.988, 210.668, 211.628, 211.868, 212.628, 213.568, 214.528, 215.468, 215.958, 216.908, 217.388, 218.368, 219.308, 219.788},
}

game.gamepadButtonList = {
	a = true,
	b = true,
	x = true,
	y = true, 
	back = true,
	start = true,
	guide = true,
	dpup = true, 
	dpdown = true,
	dpright = true,
	dpleft = true,
	leftshoulder = true,
	rightshoulder = true,
	lefttrigger = true,
	righttrigger = true,
	lanalogleft = true,
	lanalogright = true,
	lanalogup = true,
	lanalogdown = true,
	ranalogleft = true,
	ranalogright = true,
	ranalogup = true,
	ranalogdown = true,
	leftstick = true,
	rightstick = true
}

-- DATA STUFF FIRST
selected_mino = 1
function create_data(newScore, update)

	if not update then data = TSerial.unpack(love.filesystem.read(dataName)) end

	data.misc.cpAccuracy = data.misc.accuracy or 0.5
	data.gamepadControls = data.gamepadControls and data.gamepadControls or defaultGamepad
	data.approachMinoPos = data.approachMinoPos and data.approachMinoPos or 1
	data.misc = data.misc and data.misc or {}
	data.misc.smoothMovement = data.misc.smoothMovement or 1
	data.bgOpacity = data.bgOpacity or 0.5
	data.misc.skin = data.misc.skin or "default"

	 local tab = {
		["handling"] = clone(handling),
		["controls"] = clone(key),
		["gamepadControls"] = clone(data.gamepadControls),
		["resolution_selection"] = selected_resolution,
		["tetromino_selection"] = selected_mino,
		["piece_flash"] = piece_flash,
		["board_background"] = bg_color,
		["volume"] = clone(data.volume),
		["scores"] = clone(data.scores),
		["misc"] = clone(data.misc),
		["bgOpacity"] = data.bgOpacity,
		["boardZoom"] = data.boardZoom,
		["approachMinoPos"] = data.approachMinoPos
	}


	if newScore and not tab.scores[newScore.mapID] then tab.scores[newScore.mapID] = {} end

	if newScore then
		if not tab.scores[newScore.mapID][game.songDifficulty] or tab.scores[newScore.mapID][game.songDifficulty].score <= newScore.score then
			game.highScore = true
			tab.scores[newScore.mapID][cleanString(game.songDifficulty)] = clone(newScore)
			


			local savingDifficulty = cleanString(newScore.difficulty)

			print("diff: ".. savingDifficulty)
			--love.filesystem.createDirectory("/replays/" .. tostring(newScore.mapID))
			love.filesystem.createDirectory("replays/" .. tostring(newScore.mapID) .. "/" .. savingDifficulty)


			love.filesystem.write("/replays/" .. tostring(newScore.mapID) .. "/"..savingDifficulty.."/replay.chr", TSerial.pack(game.replayData, {}, false))


			playSFX(highScore_snd)
		else
			game.highScore = false
		end
	end

	return tab
end


handling = {}

slowHandling = {}
slowHandling.sdr = 15
slowHandling.das = 0.25
slowHandling.arr = 1/18

defaultHandling = {}
defaultHandling.sdr = 20
defaultHandling.das = 0.2
defaultHandling.arr = 1/25

fastHandling = {}
fastHandling.sdr = 30
fastHandling.das = 0.1
fastHandling.arr = 0

defaultControls = {}
defaultControls.cwrotate = "up"
defaultControls.ccwrotate = "z"
defaultControls.rotate180 = "x"
defaultControls.left = "left"
defaultControls.right = "right"
defaultControls.harddrop = "space"
defaultControls.softdrop = "down"
defaultControls.hold = "lshift"
defaultControls.restart = "r"

defaultGamepad = {
	cwrotate = "b",
	ccwrotate = "a",
	rotate180 = "y",
	left = "dpleft",
	right = "dpright",
	harddrop = "dpup",
	softdrop = "dpdown",
	hold = "leftshoulder",
	restart = "guide"
}

chexControls = {}
chexControls.cwrotate = "right"
chexControls.ccwrotate = "left"
chexControls.left = "a"
chexControls.right = "d"
chexControls.harddrop = "w"
chexControls.softdrop = "s"
chexControls.hold = "lshift"
chexControls.restart = "r"

defaultData = {
		["handling"] = defaultHandling,
		["controls"] = defaultControls,
		["resolution_selection"] = 1,
		["tetromino_selection"] = 1,
		["piece_flash"] = true,
		["board_background"] = 1,
		["screenZoom"] = 1,
		["volume"] = {
			master = 1,
			music = 0.5,
			sfx = 1
		},
		["misc"] = {

		},
		["scores"] = {

		},
	}

data = love.filesystem.read(dataName)

if not data then
	print("no data!")
	data = defaultData
	love.filesystem.write(dataName, TSerial.pack(defaultData, {}, true))
else
	print(data)
	data = TSerial.unpack(data, true)
end


handling = data["handling"]
selected_mino = type(data["tetromino_selection"]) == "number" and data["tetromino_selection"] or 1
key = data["controls"]
selected_resolution = data["resolution_selection"]
piece_flash = data["piece_flash"]
bg_color = data["board_background"] and data["board_background"] or false
data.gamepadControls = data.gamepadControls and data.gamepadControls or defaultGamepad

love.filesystem.createDirectory("maps")
love.filesystem.createDirectory("temp")

local mp
function collectMaps(dirList)
	local mapz = {}

	for _, dir in pairs(dirList) do
		
		game.mapFiles = love.filesystem.getDirectoryItems(dir)

		for _, mapName in pairs(game.mapFiles) do
			local diffs = love.filesystem.getDirectoryItems(dir.."/" .. mapName .. "/map")

			for _, diff in pairs(diffs) do
				local abort = false
				mp = TSerial.unpack(love.filesystem.read(dir.."/" .. mapName .. "/map/" .. diff), true)




				local filen = (mp[1].songPointer and mp[1].songPointer) or "song.mp3"
				mp[1].song = dir.."/" .. mapName .. "/" .. filen

				local filen = (mp[1].bgPointer and mp[1].bgPointer) or "background.png"
				mp[1].background = dir.."/" .. mapName .. "/" .. filen

				if not love.filesystem.getInfo(mp[1].background) then
					mp[1].background = "assets/skins/default/defaultMapBG.png"
				end

				if not love.filesystem.getInfo(mp[1].song) then
					abort = true
				end

				mp[1].selectionBg = love.filesystem.getInfo(dir.."/" .. mapName .. "/altBackground.png") and (dir.."/" .. mapName .. "/altBackground.png") or nil
				mp[1].video = love.filesystem.getInfo(dir.."/" .. mapName .. "/video.ogv") and (dir.."/" .. mapName .. "/video.ogv") or nil

				print(mp[1].name)

				if not abort then table.insert(mapz, mp) end
			end
		end
	end
	return mapz
end

function collectMap(dirList)
	local mapz = {}

	for _, dir in pairs(dirList) do
		
		game.mapFiles = love.filesystem.getDirectoryItems(dir)

		for _, mapName in pairs(game.mapFiles) do
			local diffs = love.filesystem.getDirectoryItems(dir.."/" .. mapName .. "/map")

			for _, diff in pairs(diffs) do
				local abort = false
				mp = TSerial.unpack(love.filesystem.read(dir.."/" .. mapName .. "/map/" .. diff), true)




				local filen = (mp[1].songPointer and mp[1].songPointer) or "song.mp3"
				mp[1].song = dir.."/" .. mapName .. "/" .. filen

				local filen = (mp[1].bgPointer and mp[1].bgPointer) or "background.png"
				mp[1].background = dir.."/" .. mapName .. "/" .. filen

				if not love.filesystem.getInfo(mp[1].background) then
					mp[1].background = "assets/skins/default/defaultMapBG.png"
				end

				if not love.filesystem.getInfo(mp[1].song) then
					abort = true
				end

				mp[1].selectionBg = love.filesystem.getInfo(dir.."/" .. mapName .. "/altBackground.png") and (dir.."/" .. mapName .. "/altBackground.png") or nil
				mp[1].video = love.filesystem.getInfo(dir.."/" .. mapName .. "/video.ogv") and (dir.."/" .. mapName .. "/video.ogv") or nil

				print(mp[1].name)

				if not abort then table.insert(mapz, mp) end
			end
		end
	end
	return mapz
end













--- VARIABLE STUFF



last_data = false

map_data = false
map_position = 1

game.skin = data.misc.skin and data.misc.skin or "elegant"

local minos = love.filesystem.getDirectoryItems("/assets/skins/"..game.skin.."/minos")
mino_skin_counter = #minos


boardbg_img = love.graphics.newImage("/assets/skins/"..game.skin.."/whiteBoardBG.png")
board_img = love.graphics.newImage("/assets/skins/"..game.skin.."/tetris_board.png")
next_img = love.graphics.newImage("/assets/skins/"..game.skin.."/next_queue.png")
score_img = love.graphics.newImage("/assets/skins/"..game.skin.."/score_area.png")
--bg_img = love.graphics.newImage("/assets/skins/"..game.skin.."/menuBG.png")
aroundboard_img = love.graphics.newImage("/assets/skins/"..game.skin.."/board_surround.png")
autodrop_img = love.graphics.newImage("/assets/skins/"..game.skin.."/autodrop.png")
logo_img = love.graphics.newImage("/assets/skins/"..game.skin.."/logo.png")
menu_bg = love.graphics.newImage("/assets/skins/"..game.skin.."/menuBG.png")
menu_ui = love.graphics.newImage("/assets/skins/"..game.skin.."/menu_view.png")
mino_img = love.graphics.newImage("/assets/skins/"..game.skin.."/minos/"..selected_mino..".png")
ghostmino_img = love.graphics.newImage("/assets/skins/"..game.skin.."/ghost_mino.png")
flashmino_img = love.graphics.newImage("/assets/flash_mino.png")
mapselect_overlay_img = love.graphics.newImage("/assets/map_select/Overlay.png")

game.defaultBG_img = love.graphics.newImage("/assets/skins/"..game.skin.."/defaultMapBG.png")
game.hsContain_img = love.graphics.newImage("/assets/skins/"..game.skin.."/highScoreContainer.png")
game.dangerFlash_img = love.graphics.newImage("/assets/skins/"..game.skin.."/dangerFlash.png")
game.sparkle_img = love.graphics.newImage("/assets/skins/"..game.skin.."/sparkle.png")
game.perfect_img = love.graphics.newImage("/assets/skins/"..game.skin.."/perfect.png")
game.nice_img = love.graphics.newImage("/assets/skins/"..game.skin.."/nice.png")
game.holdSave_img = love.graphics.newImage("/assets/skins/"..game.skin.."/holdSave.png")
game.miss_img = love.graphics.newImage("/assets/skins/"..game.skin.."/miss.png")



game.mapSelectOverlay_img = love.graphics.newImage("/assets/skins/"..game.skin.."/map_select_overlay.png")
game.menuBeatCircle_img = love.graphics.newImage("/assets/skins/"..game.skin.."/menuBeatCircle.png")


game.countdown3_img = love.graphics.newImage("/assets/skins/"..game.skin.."/countdown_3.png")
game.countdown2_img = love.graphics.newImage("/assets/skins/"..game.skin.."/countdown_2.png")
game.countdown1_img = love.graphics.newImage("/assets/skins/"..game.skin.."/countdown_1.png")


game.pauseParticle = love.graphics.newImage("/assets/skins/"..game.skin.."/pauseParticle.png")

--game.approachmino_img = love.graphics.newImage("/assets/skins/"..game.skin.."/approachMino.png")

local appendList = {1,2,3,4,5,6,7, "a", "b", "c", "d", "e", "f", "g"} -- keep as an array for triminos

game.approachPieces = {}

for _, item in pairs(appendList) do
	game.approachPieces[item] = love.graphics.newImage("/assets/skins/"..game.skin.."/approachMinos/"..tostring(item)..".png")
end

game.rankLetters = {
	["?"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/unknown.png"),
	["F"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/F.png"),
	["E"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/E.png"),
	["D"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/D.png"),
	["C"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/C.png"),
	["B"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/B.png"),
	["A"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/A.png"),
	["S"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/S.png"),
	["SS"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/SS.png"),
	["X"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/X.png"),
	["P"] = love.graphics.newImage("/assets/skins/"..game.skin.."/ranks/P.png"),
}


game.soundFont = "default"

lockwait_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/lock_wait.ogg", "static")
topout_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/topout.mp3", "static")
harddrop_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/harddrop.ogg", "static") 
tclick_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/spin_t_piece.ogg", "static") 
tspin_none_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/tspin_nolines.ogg", "static") 
tspin_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/tspin_lines.ogg", "static") 
quad_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/quad.ogg", "static") 
hold_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/hold.ogg", "static") 
move_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/move.wav", "static") 
rotate_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/rotate.ogg", "static") 
lock_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/lock.ogg", "static") 
lineclear_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/line_clear.ogg", "static")
garbage_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/garbage.ogg", "static")
newboard_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/newBoard.ogg", "static")
highScore_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/highScore.mp3", "stream")
halfBeat_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/halfBeat.ogg", "static")

game.holdSave_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/holdSave.ogg", "static")
game.legend_snd = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/legend.mp3", "static")


combo_sounds = {}

for i = 1, 6 do
	combo_sounds[i] = love.audio.newSource("/assets/soundfonts/"..game.soundFont.."/combo_sfx/" .. i .. ".ogg", "static")
end



game.falling_star_img = love.graphics.newImage("/assets/maps/space_fractal/falling_star.png")

mode = "Sprint"
autodrop_skip = false
compat_mode = false
map_data = false
old_time = 0
score = 0
last_move = ""
lm_timer = 0
start_position_r = 0
start_position = 0
song = false
total_time = 0
selected_menu_item = 1
auto_drop = false
last_input = ""
distance_dropped = 0
b2b = -1
waitingForInput = false
game_lines = 0
lines_goal = 150
total_pieces = 0

startStats = {
	["tetrises"] = 0,
	["tspin singles"] = 0,
	["tspin doubles"] = 0,
	["tspin triples"] = 0,
	["b2bs"] = 0,
	["max combo"] = 0
}

stats = startStats










game.dt = 0
game.board_live_offset = {0,0}
game.lastDropTime = 0
game.hp = 0.5
game.hpDrain = 0.1
game.totalBeats = 0
game.beatCount = 1
game.accuracy = 0
game.timeSinceBeat = 0
game.timeTilNextBeat = 100
game.approachRate = 1
game.approachTime = 0.3
game.approachRatio = 0
game.customDraw = nil
game.bgOpacity = 0.5
game.switch = false
game.lastBeatColor = false
game.mapListing = false
game.selectedMap = 1
game.selectedDifficulty = 1
game.mapBg = false
game.transition = false
game.transitionTime = 0
game.transitionGoal = "Menu"
game.musicVolume = 0.35
game.songFadeOut = {}
game.mapSelectSong = false
game.startOffset = 0
game.dangerFlashO = 0
game.menuFlashPos = 1
game.gamepadButtons = {}
game.halfBeatTracker = {}
game.hpBar = 0
game.tweenPieceX = 0
game.tweenPieceY = 0
game.buttonMappings = {}
game.replayPlaybackRate = 1
game.oldStartOffset = 0
game.perfectThreshold = 0.05 -- 0.05 seconds before and after the beat; 100ms
game.niceThreshold = 0.13 -- 260ms

game.mapGen = {}
game.mapGen.startTime = 0
game.mapGen.endTime = 5
game.mapGen.previewTime = 30
game.mapGen.offset = 0
game.mapGen.bpm = 195
game.mapGen.speed = 2


game.songDataName = false
game.songData = false
game.songSample = false

game.replayData = {}

game.replayData.pieceList = ""
game.replayData.keysDown = {}
game.replayData.checkpoints = {}
game.replayData.updatePos = 1
game.replayData.currentCP = 1
game.replayData.position = 1

game.paused = false
game.pauseParticleSwitch = false
game.pauseOptions = {
				"Resume",
				"Restart",
				"Return to Menu"
			}

game.sprintMap = {
	{
		["name"] = "40 Line Sprint",
		["artist"] = "chex",
		["difficulty"] = "Normal",
		["id"] = -100,
		["gravity"] = 1,
		["lockTime"] = 1, 

	},
	{

	}
}

game.testMap = {
	{
		["name"] = "Test Map",
		["artist"] = "???",
		["difficulty"] = "Normal",
		["id"] = -99999999999,
		["gravity"] = 1,
		["lockTime"] = 1, 
		["beatmap"] = {},
		["flashTimes"] = {},
	},
	{

	}
}

movingObjects = {

}



newMap = false



game.flashTimes = false
game.flashLights = {}

combo = 0
repeat_table = {}
repeat_progress = 0
auto_drop_wait = false

flash_minos = {}

bag = false


lockTime = .5
active_piece = false
gravity = 1/10
gravity_prog = 0
arr_prog = 0
das_prog = 0
held = false
held_piece = false






--handling = clone(fastHandling)


-- INITIALIZE EDITOR VALS
editor = {}

editor.timestamps = {}--{4.299, 4.999, 5.239, 6.219, 6.899, 7.119, 8.119, 8.799, 9.099, 10.019, 10.699, 10.979, 11.939, 12.619, 12.919, 13.849, 14.559, 14.809, 15.779, 16.439, 16.719, 17.699, 18.379, 18.619, 19.598, 20.298, 20.568, 21.498, 22.208, 22.438, 23.438, 24.138, 24.418, 25.358, 25.868, 26.338, 26.858, 27.178, 27.778, 28.718, 29.718, 30.678, 31.618, 32.578, 33.538, 34.478, 35.438, 36.418, 37.358, 38.337, 39.307, 40.237, 41.217, 42.197, 43.117, 43.617, 44.117, 44.597, 45.077, 45.537, 46.017, 46.517, 46.977, 47.417, 47.937, 48.397, 48.877, 49.377, 49.857, 50.337, 50.817, 51.297, 51.757, 52.257, 52.757, 53.237, 53.677, 54.117, 54.637, 55.117, 55.617, 56.117, 56.556, 57.056, 57.536, 58.036, 58.516, 58.956, 59.436, 59.916, 60.436, 60.916, 61.396, 61.836, 62.336, 62.816, 63.316, 63.756, 64.236, 64.696, 65.196, 65.696, 66.136, 66.636, 67.136, 67.616, 68.116, 68.536, 69.056, 69.536, 70.036, 70.456, 70.976, 71.476, 71.936, 72.436, 72.916, 73.436, 73.836, 74.316, 74.836, 75.315, 75.775, 76.235, 76.735, 77.255, 77.735, 78.175, 78.635, 79.135, 79.635, 80.115, 80.575, 81.055, 81.555, 82.015, 82.475, 82.955, 83.435, 83.935, 84.395, 84.895, 85.375, 85.835, 86.315, 86.815, 87.295, 87.735, 88.235, 88.735, 89.235, 89.695, 90.155, 90.635, 91.135, 91.615, 92.135, 92.595, 93.075, 93.535, 94.034, 94.434, 94.934, 95.434, 95.934, 96.414, 96.914, 97.354, 97.834, 98.314, 98.794, 99.294, 99.754, 100.234, 100.734, 101.214, 101.694, 102.154, 102.654, 103.134, 103.634, 104.094, 104.554, 105.054, 105.554, 106.034, 106.514, 106.994, 107.474, 107.934, 108.414, 108.894, 109.334, 109.854, 110.334, 110.834, 111.274, 111.754, 112.234, 112.733, 113.233, 113.713, 114.173, 114.653, 115.133, 115.613, 116.113, 116.573, 117.033, 117.513, 117.993, 118.473, 118.953, 119.433, 119.933, 120.413, 120.893, 121.333, 121.833, 122.333, 122.773, 123.273, 123.753, 124.233, 124.733, 125.233, 125.713, 126.173, 126.653, 127.133, 127.613, 128.073, 128.533, 129.033, 129.533, 129.993, 130.473, 130.973, 131.452, 131.932, 132.412, 132.892, 133.352, 133.852, 134.332, 134.792, 135.292, 135.772, 136.232, 136.752, 137.212, 137.692, 138.172, 138.652, 139.132, 139.632, 140.132, 140.572, 141.052, 141.552, 142.012, 142.472, 142.972, 143.432, 143.912, 144.412, 144.912, 145.372, 145.832, 146.332, 146.832, 147.292, 147.772, 148.252, 148.732, 149.232, 149.672, 150.171, 150.651, 151.131, 151.631, 152.131, 152.591, 153.091, 153.551, 154.011, 154.451, 154.951, 155.451, 155.911, 156.391, 156.911, 157.371, 157.831, 158.331, 158.791, 159.271, 159.751, 160.231, 160.711, 161.211, 161.691, 162.191, 162.651, 163.131, 163.611, 164.091, 164.611, 165.051, 165.531, 166.011, 166.491, 166.991, 167.451, 167.931, 168.431, 168.891, 169.39, 169.87, 170.33, 170.83, 171.29, 171.75, 172.23, 172.73, 173.19, 173.69, 174.17, 174.63, 175.15, 175.63, 176.09, 176.57, 177.03, 177.53, 178.01, 178.49, 178.99, 179.43, 179.91, 180.43, 180.91, 181.37, 181.85, 182.31, 182.79, 183.27, 183.77, 184.27, 184.73, 185.19, 185.71, 186.19, 186.65, 187.11, 187.63, 188.11, 188.569, 189.089, 189.549, 190.009, 190.489, 190.949, 191.469, 191.949, 192.409, 192.909, 193.389, 193.849, 194.349, 194.809, 195.269, 195.749, 196.229, 196.709, 197.229, 197.669, 198.169, 198.629, 199.129, 199.609, 200.089, 200.609, 201.069, 201.529, 202.029, 202.509, 202.969, 203.429, 203.929, 204.409, 204.869, 205.349, 205.849, 206.349, 206.809, 207.288, 207.768, 208.268, 208.768, 209.228, 209.668, 210.128, 210.648, 211.148, 211.608, 212.088, 212.588, 213.028, 213.528, 214.028, 214.488, 214.968, 215.428, 215.928, 216.428, 216.888, 217.348, 217.848, 218.328, 218.788, 219.288, 219.768}
-- editor.song = love.audio.newSource("/assets/internal_maps/Perfect Case In Point/song.mp3", "static")
editor.state = "neutral"
editor.selectedBeat = 1
editor.currentBeat = 1
--editor.song:setPitch(0.75)
if editor.song then editor.song:setVolume(0.4) end
editor.bpm = 195*2
editor.offset = 2.847

for i, item in pairs(editor.timestamps) do
	editor.timestamps[i] = {editor.timestamps[i],
		{},
	}
end



function editor.add_beat(color)
	local beatRate = 1/(editor.bpm/60)
	local c = editor.offset
	local lc = c
	local oac = 999999999
	while c < editor.song:tell() do
		c = c + beatRate
		local accuracy = math.abs(editor.song:tell() - c)

		if accuracy > oac then
			c = lc
			break
		end

		lc = c
		oac = accuracy
	end

	table.insert(editor.timestamps, {
		c,
		{

		},
		color
	})
end








function fresh_board()
	local b = {}

for i = 1,20 do
	b[i] = {0,0,0,0,0,0,0,0,0,0}
end	

	return b
end


local p = {}


		p.lastFlashPos = 0
		p.progress = 0
		p.sunFlash = 0
		p.interval = 0
		p.switch = false
		p.bg_grid = love.graphics.newImage("/assets/maps/planet_bass/bg_grid.png")
		p.bg_triangles = love.graphics.newImage("/assets/maps/planet_bass/bg_triangles.png")
		p.bg_sf = love.graphics.newImage("/assets/maps/planet_bass/bg_squares_mid.png")
		p.bg_sff = love.graphics.newImage("/assets/maps/planet_bass/bg_squares_front.png")
		p.bg_sun = love.graphics.newImage("/assets/maps/planet_bass/sun.png")
		p.sfwhite = love.graphics.newImage("/assets/maps/planet_bass/fs_white.png")
		p.bg_black = love.graphics.newImage("/assets/maps/planet_bass/blackFade.png")
		p.bg_sunset = love.graphics.newImage("/assets/maps/planet_bass/sunset_bg.png")	
		p.sun2 = love.graphics.newImage("/assets/maps/planet_bass/sun2.png")	
		p.cloud = love.graphics.newImage("/assets/maps/planet_bass/cloud.png")

function ext_data.planet_bass_draw(total_time, beatCount)
	if total_time < 1 and p.progress ~= 1 then
		p.progress = 1
		p.lastFlashPos = 0
		table.insert(movingObjects,{
			img = p.sfwhite,
			scale = {5,5},
			position = {0,0},
			opacity = 1,
			acceleration = {0,0.2},
			lifetime = 5,
			velocity = {0,0},
			color = {0,0,0},
			rotation = 0,
			layer = 3
		})		

	end

	if not p.bg_grid then return end

	if p.progress == 1 and total_time >= 4.2 then



		movingObjects["flash_left"] = {
			img = love.graphics.newImage("/assets/maps/planet_bass/flash_left.png"),
			scale = {game.swidth/800,game.sheight/600},
			position = {0,0},
			opacity = 0,
			opacityDelta = -0.05,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		}		

		movingObjects["flash_right"] = {
			img = love.graphics.newImage("/assets/maps/planet_bass/flash_right.png"),
			scale = {game.swidth/800,game.sheight/600},
			position = {0,0},
			opacity = 0,
			opacityDelta = -0.05,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		}		

		movingObjects[1] = {
			img = p.bg_grid,
			scale = {game.sheight/800,game.sheight/800},
			position = {0,0},
			opacity = 1,
			velocity = {-0.125, 0},
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}				

		movingObjects[2] = {
			img = p.bg_triangles,
			scale = {game.sheight/600,game.sheight/600},
			position = {0,0},
			opacity = 1,
			velocity = {-0.3, 0},
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}			

		movingObjects[3] = {
			img = p.bg_sf,
			scale = {game.sheight/600,game.sheight/600},
			position = {0,0},
			opacity = 1,
			velocity = {-0.6, 0},
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}		

		movingObjects[4] = {
			img = p.bg_sff,
			scale = {game.sheight/600,game.sheight/600},
			position = {0,0},
			opacity = 1,
			velocity = {-1, 0},
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}

		movingObjects[5] = {
			img = p.bg_black,
			scale = {game.swidth/800,game.sheight/600},
			position = {0,-(game.sheight/1.5)},
			opacity = 1,
			velocity = {0, 0.1},
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}

		movingObjects["pbsun"] = {
			img = p.bg_sun,
			scale = {game.swidth/800,game.swidth/800},
			position = {0,game.sheight/2},
			velocity = {0,-0.16 * (game.sheight/600*2)},
			opacity = 1,
			color = {1,1,1},
			rotation = 0,
			layer = 1,
			acceleration = {0,0.0001 * (600/game.sheight)}
		}

		table.insert(movingObjects,{
			img = p.sfwhite,
			scale = {5,5},
			position = {0,0},
			opacity = 1,
			opacityDelta = -0.0075,
			lifetime = 5,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		})		

		p.progress = 2
	end



	if p.progress == 2 and total_time > 27.2 then
		movingObjects.pbsun.velocity = {0,0}
		movingObjects.pbsun.acceleration = {0,0}
		p.progress = 3
		movingObjects[5] = nil

		table.insert(movingObjects,{
			img = p.sfwhite,
			scale = {5,5},
			position = {0,0},
			opacity = .5,
			opacityDelta = -0.0075,
			lifetime = 5,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		})	
	end	

	if p.progress == 3 and total_time > 57.8 then

	movingObjects.pbsun.position = {movingObjects.pbsun.position[1], movingObjects.pbsun.position[2] + 2000}

		table.insert(movingObjects,{
			img = p.sfwhite,
			scale = {5,5},
			position = {0,0},
			opacity = .7,
			opacityDelta = -0.0075,
			lifetime = 5,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		})	

		movingObjects[5] = {
			img = p.bg_sunset,
			scale = {game.swidth/800,game.sheight/600},
			position = {0,0},
			opacity = 1,
			color = {1,1,1},
			rotation = 0,
			layer = 1
		}

		movingObjects[6] = {
			img = p.cloud,
			scale = {game.swidth/800,game.sheight/600},
			position = {0,0},
			velocity = {-0.1, 0},
			opacity = 1,
			color = {1,1,1},
			scale = {2*(game.sheight/600),2*(game.sheight/600)},
			rotation = 0,
			layer = 1
		}		

		movingObjects[7] = {
			img = p.sun2,
			scale = {game.sheight/600/2, game.sheight/600/2},
			position = {game.swidth - (game.swidth/5),game.sheight/3 + (game.sheight == 720 and 150 or 0)},
			opacity = 1,
			color = {1,1,1},
			rotation = 0,
			velocity = {-0.15 * (game.swidth/800), 0},
			layer = 1
		}		

		p.progress = 4
	end

	if p.sunFlash > 0 then
		p.sunFlash = p.sunFlash - 0.0005 * game.dt * 60
	end

	p.interval = p.interval + game.dt

	if p.interval > 0.05 and total_time > 27.2 then
		local scalef = (math.random(-2,2)/10)
		local segment = math.random(1,2) == 2 and (game.swidth/5) or game.swidth - (game.swidth/5)
		table.insert(movingObjects,{
			img = love.graphics.newImage("/assets/maps/planet_bass/star.png"),
			scale = {(1 + scalef)/2,(1 + scalef)/2},
			position = {segment + math.random(-100,100),(game.sheight/5) + math.random(-50,250)},
			opacity = 1,
			lifetime = .3,
			color = {1,1,1},
			rotation = 0,
			layer = 2
		})		
		p.interval = 0	
	end
	-----------------------------------------------------------
	if p.lastFlashPos ~= game.flashPos then
		p.sunFlash = 0.025

		p.switch = not p.switch

		if p.switch and movingObjects["flash_right"] then
			movingObjects["flash_right"].opacity = 0.3
		elseif movingObjects["flash_left"] then
			movingObjects["flash_left"].opacity = 0.3
		end
	end

	if movingObjects.pbsun then
		movingObjects.pbsun.scale = {game.swidth/800 + p.sunFlash,game.swidth/800 + p.sunFlash}
	end

	p.lastFlashPos = game.flashPos
end


for i, item in pairs(ext_data.beatmap["welcome to my mind"]) do
	ext_data.beatmap["welcome to my mind"][i] = item - 0.1
end

for i, item in pairs(ext_data.beatmap["planet bass"]) do
	ext_data.beatmap["planet bass"][i] = item - 0.1
end

for i, item in pairs(ext_data.beatmap["planet bass expert"]) do
	--ext_data.beatmap["planet bass expert"][i] = item - 0.1
end

local n = 0.35714285714
local total = 0
local tab = {}
local max = 188

while total < max do
    total = total + n
    table.insert(tab, total)
end

local t = ""

for _, i in pairs(tab) do
    t = t .. tostring(i) .. ", "
end

print(t)

wallKickDefault = {
	{{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}}, -- 0>1
	{{0,0},{1,0},{1,-1},{0,2},{1,2}}, -- 1>0
	{{0,0},{1,0},{1,-1},{0,2},{1,2}}, -- 1>2
	{{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}}, -- 2>1
	{{0,0},{1,0},{1,1},{0,-2},{1,-2}}, -- 2>3
	{{0,0},{-1,0},{-1,-1},{0,2},{-1,2}}, -- 3>2
	{{0,0},{-1,0},{-1,-1},{0,2},{-1,2}}, -- 3>0
	{{0,0},{1,0},{1,1},{0,-2},{1,-2}}  -- 0>3
}

wallKickI = {
	{{0,0},{-2,0},{1,0},{-2,-1},{1,2}}, -- 0>1
	{{0,0},{2,0},{-1,0},{2,1},{-1,-2}}, -- 1>0
	{{0,0},{-1,0},{2,0},{-1,2},{2,-1}}, -- 1>2
	{{0,0},{1,0},{-2,0},{1,-2},{-2,1}}, -- 2>1
	{{0,0},{2,0},{-1,0},{2,1},{-1,-2}}, -- 2>3
	{{0,0},{-2,0},{1,0},{-2,-1},{1,2}}, -- 3>2
	{{0,0},{1,0},{-2,0},{1,-2},{-2,1}}, -- 3>0
	{{0,0},{-1,0},{2,0},{-1,2},{2,-1}}, -- 0>3

}

wallKickO = { --fuck it lol
	{{0,0}},
	{{0,0}},
	{{0,0}},
	{{0,0}},
	{{0,0}},
	{{0,0}},
	{{0,0}},
	{{0,0}}
}

pieces = {
	[1] = { --I
		{0,0,0,0},
		{1,1,1,1},
		{0,0,0,0},
		{0,0,0,0}
	},
	[2] = { --J
		{2,0,0},
		{2,2,2},
		{0,0,0}
	},
	[3] = { --L
		{0,0,3},
		{3,3,3},
		{0,0,0}
	},
	[4] = { --S
		{0,4,4},
		{4,4,0},
		{0,0,0}
	},
	[5] = { --Z
		{5,5,0},
		{0,5,5},
		{0,0,0}
	},
	[6] = { --T
		{0,6,0},
		{6,6,6},
		{0,0,0}
	},
	[7] = { --O
		{7,7},
		{7,7},

	},
	["a"] = { 
		{0,0,0},
		{9,9,9},
		{0,0,0}
	},
	["b"] = { 
		{0,0,0},
		{9,9,9},
		{0,0,0}
	},
	["c"] = { 
		{0,9},
		{9,9},
	},
	["d"] = { 
		{9,0},
		{9,9},
	},
	["e"] = { 
		{0,9},
		{9,9},
	},
	["f"] = { 
		{9,0},
		{9,9},
	},
	["g"] = { 
		{0,0,0},
		{9,9,9},
		{0,0,0}
	},
	["A"] = {
		{0,0,0,0},
		{0,1,1,0},
		{0,0,0,0},
		{0,0,0,0}
	},
	["B"] = {
		{0,0,0,0},
		{0,2,2,0},
		{0,0,0,0},
		{0,0,0,0}
	},
	["C"] = {
		{0,0,0,0},
		{0,4,4,0},
		{0,0,0,0},
		{0,0,0,0}
	},
	["D"] = {
		{0,0,0,0},
		{0,6,6,0},
		{0,0,0,0},
		{0,0,0,0}
	},
}



piece_colors = {
	{0, 230/255, 255/255},
	{0, 60/255, 255/255},
	{255/255, 145/255, 0},
	{77/255,255/255,0},
	{255/255,0,0},
	{188/255,0,255/255},
	{255/255, 230/255, 0},
	{0.5,0.5,0.5},
	{200/255,200/255,200/255},
	{0.1,0.1,0.1},
	["a"] = {1,1,1},--{0, 230/255, 255/255},
	["b"] = {1,1,1},--{255/255, 145/255, 0},
	["c"] = {1,1,1},--{0, 60/255, 255/255},
	["d"] = {1,1,1},--{1,230/255,0},
	["e"] = {1,1,1},--{77/255,255/255,0},
	["f"] = {1,1,1},--{255/255,0,0},
	["g"] = {1,1,1},--{188/255,0,255/255},
	["A"] = {0, 230/255,255/255},
	["B"] = {0, 60/255, 255/255},
	["C"] = {77/255,255/255,0},
	["D"] = {188/255,0,255/255},
}





-- MENU DATA
levelSelectMenu = {
	"Level 1",
	"???",
	"Level X",
	"Back to Mode Select"
}




cheeseMenu = {
	"Cheese Race",
	"Cheese Race - Double Time",
	"Cheese Race - Impossible",
	"Back to Classic Modes"
}

modeMenu = {
	"CAMPAIGN",
	"CLASSIC",
	"EXTRAS",
	"Back to Main Menu"
}

gameplayMenu = {
	"Approach Piece Location",
	"Active Piece Movement",
	"Board Background",
	"Back to Options"
}

videoSettings = {
	"Tetromino Design",
	"Piece Flash",
	"Screen Zoom",
	"Background Opacity",
	"Toggle Fullscreen",

	"Back to Options"
}

classicModes = {
	"40 Line Sprint",
	"Marathon",
	"Cheese Races",
	"Free Play",
	"Back to Mode Select"
}
mainMenu = {
	"PLAY",
	"EXTRAS",
	"OPTIONS",
	"QUIT"
}

firstControlsMenu = {
	"Move Piece Left",
	"Move Piece Right",
	"Soft Drop",
	"Hard Drop",
	"Rotate CW (Right)",
	"Rotate CCW (Left)",
	"Rotate 180 Degrees",
	"Hold Piece",

	"Let's go!"
}

firstGamepadMenu = {
	"-Move Piece Left",
	"-Move Piece Right",
	"-Soft Drop",
	"-Hard Drop",
	"-Rotate CW (Right)",
	"-Rotate CCW (Left)",
	"-Rotate 180 Degrees",
	"-Hold Piece",
	"Let's go!"
}

firstTimeMenu = {
	"Set up controls",
	"Use default controls (guideline)"
}

setupControlsMenu = {
	"-Keyboard Controls",
	"-Gamepad Controls",
	"Use default controls (guideline)"	
}



extrasMenu = {
	"Free Play",
	"40 Line Sprint",
	"Basic Beatmap Generator",

	"Back to Main Menu"
}

testMapMenu = {
	"-Map start time (Testing)",
	"-Speed:",
	"-Start Test",

	"Back to Map Generator"
}


beatmapGenMenu = {
	"-Song:",
	"-Song Offset:",
	"-Song BPM:",
	"-Song Start Time:",
	"-Song End Time:",
	"-Song Preview Time:",
	"-Test Beatmap",
	"Generate Map!",

	"Back to Extras"
}

optionsMenu = {
	"VIDEO",
	"SOUND",
	"HANDLING",
	"GAMEPLAY",
	"KEYBOARD CONTROLS",
	"GAMEPAD CONTROLS",
	"Back to Main Menu"
}


soundMenu = {
	"Master Volume",
	"Music Volume",
	"SFX Volume",
	"Back to Options"
}

controlsMenu = {
	"Move Piece Left",
	"Move Piece Right",
	"Soft Drop",
	"Hard Drop",
	"Rotate CW (Right)",
	"Rotate CCW (Left)",
	"Rotate 180 Degrees",
	"Hold Piece",
	"Quick Restart",
	"Return to Options"
}

gamepadMenu = {
	"-Move Piece Left",
	"-Move Piece Right",
	"-Soft Drop",
	"-Hard Drop",
	"-Rotate CW (Right)",
	"-Rotate CCW (Left)",
	"-Rotate 180 Degrees",
	"-Hold Piece",
	"Back to Options"
}

handlingMenu = {
	"Delayed Auto Shift",
	"Automatic Repeat Rate",
	"Soft Drop Rate",
	"PRESET: Default",
	"PRESET: Quick",
	"PRESET: Slow",
	"Back to Options"
}













garbage_list = {
	["right_well_1"]={
		{8,8,8,8,8,8,8,8,8,0}
	},
	["left_well_1"]={
		{0,8,8,8,8,8,8,8,8,8}
	},

	["LRL_tetris"] = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	},

	["RLR_tetris"] = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	},

	["JLJ"] = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{8,8,8,8,0,0,8,2,2,8},
	{8,8,8,8,0,8,8,2,8,8},
	{8,8,8,8,0,8,8,2,8,8},
	{8,8,8,0,0,8,3,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	{8,8,8,8,0,0,8,2,2,8},
	{8,8,8,8,0,8,8,2,8,8},
	{8,8,8,8,0,8,8,2,8,8},
	},

	["LJL"] = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{8,8,8,0,0,8,3,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	{8,8,8,8,0,0,8,2,2,8},
	{8,8,8,8,0,8,8,2,8,8},
	{8,8,8,8,0,8,8,2,8,8},
	{8,8,8,0,0,8,3,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	{8,8,8,8,0,8,8,3,8,8},
	}
}

newBoard = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
}

local garbage_table = {
	{8,0,8,8,8,8,8,8,8,8},
	{8,8,0,8,8,8,8,8,8,8},
	{8,8,8,0,8,8,8,8,8,8},
	{8,8,8,8,0,8,8,8,8,8},
	{8,8,8,8,8,0,8,8,8,8},
	{8,8,8,8,8,8,0,8,8,8}
}

local replacementBoard = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,8,8,8,8,8,8,8,8},
	{0,0,0,8,8,8,8,8,8,8},
	{8,8,0,8,8,8,8,8,8,8},
	{8,0,0,8,8,8,8,8,8,8},
	{8,0,0,0,8,8,8,8,8,8},
	{8,8,0,8,8,8,8,8,8,8},
	{8,8,0,8,8,8,8,8,8,8},
}

