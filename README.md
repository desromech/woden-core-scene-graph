# Woden Core - Scene Graph component
## Loading in Pharo:

The minimalistic scene graph and associated renderer component be loaded in a standard Pharo 11 image by doing the following in a Playground:
```smalltalk
EpMonitor disableDuring: [
    Author useAuthor: 'Load' during: [
        Metacello new
            baseline: 'WodenSceneGraph';
            repository: 'github://desromech/woden-core-scene-graph';
            onConflictUseIncoming;
            load
    ]
]
```

See the **WDSceneExamples** class for examples on how to use this API.

## Loading in Squeak:

This component can be loaded in Squeak 6 by doing the following in a Workspace:

```smalltalk
    Metacello new
        baseline: 'WodenSceneGraph';
        repository: 'github://desromech/woden-core-scene-graph';
        onConflictUseIncoming;
        load
```

On Squeak the AbstractGPU library must be installed manually, look for the latest release on https://github.com/desromech/abstract-gpu for find the binary library. Download the release for your platform in a folder that can be found by the Squeak VM, and perform a save and quit of the image.
