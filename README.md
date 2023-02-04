# fly-baremaps

An Alpine LTS image with the latest [Baremaps](https://github.com/apache/incubator-baremaps), compiled and configured for [Fly.io](https://fly.io).

## Usage

`$ fly launch`

Choose your app name and create a postgres instance. Do not deploy.

Depending on how much of the world you won't to import you will need a volume to store the data.

`fly volumes create data --size 10`

You will also need to [extend the volume of the postgres instance](https://fly.io/docs/reference/volumes/#creating-volumes) to accommodate the data.

Add to your fly.tpl:

```
[build]
   image = "ghcr.io/tyrauber/fly-baremaps:main"
```

Now deploy.

`$ fly deploy`

When it's done deploying. We need to add some data to our database.

`$ fly ssh console`

## Natural Earth
`> baremaps workflow execute --file examples/naturalearth/workflow.json`

`$ fly open`
