# TensorFlow Lite GPU Delegate missing class warnings
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Additional rules to preserve TensorFlow Lite classes
-keep class org.tensorflow.** { *; }
-keepattributes *Annotation*
