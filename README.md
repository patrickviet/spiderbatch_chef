SpiderBatch
===========

Multi server execution with data
--------------------------------

*Prerequisite* : the host.domain,com server must run Redis.

Usage

You configure a queue, with a command, host, (port), in attributes.
Example:

```
'spiderbatch' => {
  'conf' => {
    'some_queue_name' => {
      'host'    => 'host.domain.com',
      'command' => '/path/to/mycmd',
    }, 
  }
}


```

You run the recipe ```spiderbatch::node```   on nodes that will subscribe to this.
You run the recipe ```spiderbatch::server``` on nodes that will only publish

To publish, you run ```spiderbatch_publish <queue_name>``` and pipe your input to the STDIN of it.
To subscribe, your command must fetch that data from STDIN.

Here is a really simple full example in PHP, that updates redis.


Configuration:
```
  'spiderbatch' => {
    'conf' => {
      'redis_update' => {
        'host' => 'newcron.dginfra.net',
        'command' => '/some_path/spiderbatch_example_node.php',
      },
    }
  },
```

spiderbatch_example_node.php
```php
#!/usr/bin/php
<?

$redis = new Redis();
$redis->connect('127.0.0.1');

$json_raw = file_get_contents('php://stdin');

$my_content = json_decode($json_raw, TRUE);


foreach($my_content as $cmd) {
  var_dump($cmd);
  echo $redis->{$cmd['cmd']}($cmd['key'], $cmd['val']);
}
```

spiderbatch_example_server.php
```php
#!/usr/bin/php
<?
$data = array(
  array(
    'cmd' => 'set',
    'key' => 'spiderbatch_test1',
    'val' => time(),
  ),
  array(
    'cmd' => 'set',
    'key' => 'spiderbatch_test2',
    'val' => rand(),
  ),
);

$fp = popen('spiderbatch_publish redis_update', 'w');

fputs($fp, json_encode($data));
fclose($fp);

```
