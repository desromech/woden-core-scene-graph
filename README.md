# Woden Core - Scene Graph component
## Loading in Pharo:

The minimalistic scene graph and associated renderer component be loaded in a standard Pharo 9 image by doing the following in a Playground:
```smalltalk
Metacello new
   baseline: 'WodenSceneGraph';
   repository: 'github://desromech/woden-core-scene-graph';
   onConflictUseIncoming;
   load
```

See the **WDSceneExamples** class for examples on how to use this API.
