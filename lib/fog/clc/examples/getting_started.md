# Getting started: the compute service

You'll need a CLC account and API key to use this provider.

Get one from http://www.digitalclc.com.

To generate the API key, login to the CLC web panel and go to
'My Settings -> API Access -> Generate a new API key'.

Write down the Client Key and API Key, you'll need both to use the service.


## Connecting, retrieving and managing server objects

Before we start, I guess it will be useful to the reader to know
that Fog servers are 'droplets' in CLC's parlance.
'Server' is the Fog way to name VMs, and we have
respected that in the CLC's Fog provider.

First, create a connection to the host:

```ruby
require 'fog'

dclc = Fog::Compute.new({
  :provider => 'CLC',
  :digitalclc_api_key   => 'poiuweoruwoeiuroiwuer', # your API key here
  :digitalclc_client_id => 'lkjasoidfuoiu'          # your client key here
})
```

## Listing servers

Listing servers and attributes:

```ruby
dclc.servers.each do |server|
  # remember, servers are droplets
  server.id
  server.name
  server.state
  server.backups_enabled
  server.image_id
  server.flavor_id # server 'size' in CLC's API parlance
  server.region_id
end
```

## Server creation and life-cycle management

Creating a new server (droplet):

```ruby
server = dclc.servers.create :name => 'foobar',
                               # use the first image listed
                               :image_id  => dclc.images.first.id,
                               # use the first flavor listed
                               :flavor_id => dclc.flavors.first.id,
                               # use the first region listed
                               :region_id => dclc.regions.first.id
```

The server is automatically started after that.

We didn't pay attention when choosing the flavor, image and region used
but you can easily list them too, and then decide:

```ruby
dclc.images.each do |image|
  image.id
  image.name
  image.distribution
end

dclc.flavors.each do |flavor|
  flavor.id
  flavor.name
end

dclc.regions.each do |region|
  region.id
  region.name
end

```

Rebooting a server:

```ruby
server = dclc.servers.first
server.reboot
```

Power cycle a server:

```ruby
server.power_cycle
```

Destroying the server:

```ruby
server.destroy
```


