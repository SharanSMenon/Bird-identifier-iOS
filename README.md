#  Bird Identifier App

An AI-powered app that can identify up to 964 species of birds. The app uses CoreML for fast identification.

The app makes calls to the iNaturalist API to obtain images of Birds.

## Features

- Fast, AI-powered bird identification
- Upload photos from your photo library or quickly shoot a photo with your camera
- Learn about your bird and view similar species.
- A Species browser that allows you to see all the species the model can identify, and discover new species.
- Save your observations for later reference. Deleting is supported too
- Offline identification
- Fast load times (no non-apple frameworks are used)

## Bugs

If you find a bug, report it in the Issues tab.

## Model

The model was trained on a subset of the iNaturalist 2017 dataset. The model is based on a MobileNetV2 architecture. The model was then converted to CoreML via `coreml-tools`.

The model can be found here: https://tfhub.dev/google/aiy/vision/classifier/birds_V1/1

Created by Sharan Sajiv Menon.
