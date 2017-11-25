<?php

class ConsistentHash
{
    private $_name = '';
    private $_hashAlgo = 'md5';
    
    private $_circle = [];
    private $_bucket = [];
    private $_capacity = 0;
    private $_virtNum = 0;
    
    public function __construct($name = 'consisten_hash',$hashAlgo = 'md5')
    {
        $this->_name = $name;
        $this->_capacity = 1<<16;
        $this->_virtNum = (1<<8)-1;
        if (function_exists($hashAlgo)) {
            $this->_hashAlgo = $hashAlgo;
        }
    }
    public function printCapacity()
    {
        print $this->_capacity;
        echo PHP_EOL;
    }
    
    public function printVirtNum()
    {
        print $this->_virtNum;
        echo PHP_EOL;
    }
    
    /**
     * 增加节点
     *
     * @param string $node
     */
    public function addNode($node)
    {
        $this->_operateNode($node, function ($node_hash) use ($node) {
            $index = $this->_locateInCircle($node_hash);
            // node_hash在circle内则不处理
            if (isset($this->_circle[$index]) && $node_hash == $this->_circle[$index]) {
                return;
            }
            // add [index => hash] to circle
            if ($index >= count($this->_circle)) {
                $this->_circle[] = $node_hash;
            } else {
                for ($i = count($this->_circle); $i >= $index && $i > 0; $i--) {
                    $this->_circle[$i] = $this->_circle[$i-1];
                }
                $this->_circle[$index] = $node_hash;
            }
            // add [hash => node] to bucket
            $this->_bucket[$node_hash] = $node;
        });
    }
    /**
     * 删除节点
     *
     * @param $node
     */
    public function removeNode($node)
    {
        $this->_operateNode($node, function ($node_hash) {
            $index = $this->_locateInCircle($node_hash);
            // node_hash不在circle内则不处理
            if ($node_hash != $this->_circle[$index]) {
                return;
            }
            $count = count($this->_circle);
            for ($i = $index; $i < $count - 1; $i++) {
                $this->_circle[$i] = $this->_circle[$i+1];
            }
            unset($this->_circle[$i]);
            unset($this->_bucket[$node_hash]);
        });
    }
    
    private function _operateNode($node, Closure $operate)
    {
        for ($i = 0; $i < $this->_virtNum; $i++) {
            $virtual = "{$node}#{$i}";
            call_user_func($operate, $this->_hash($virtual));
        }
    }
    
    
    public function lookup($key)
    {
        $keyHash = $this->_hash($key);
        $index = $this->_locateInCircle($keyHash);
    
        if ($index >= count($this->_circle)) {
            $index = 0;
        }
        if (!isset($this->_circle[$index])) {
            return false;
        }
        $node_hash = $this->_circle[$index];
        return $this->_bucket[$node_hash];
    }
    
    private function _locateInCircle($hashStr)
    {
        $l = 0;
        $h = count($this->_circle) - 1;
        while ($l <= $h) {
            $m = intval(($l + $h) / 2);
            if ($this->_circle[$m] == $hashStr) {
                return $m;
            }
            if ($this->_circle[$m] > $hashStr) {
                $h = $m - 1;
            }
            if ($this->_circle[$m] < $hashStr) {
                $l = $m + 1;
            }
        }
        return intval(($l + $h + 1) / 2);
    }
    private function _hash($key)
    {
        $hashkey=hexdec(substr(call_user_func($this->_hashAlgo,$key),0,15))%$this->_capacity;
        return $hashkey;
    }
    public function printCircle()
    {
        var_dump( $this->_circle);
    }
}

$consistenHash = new ConsistentHash();
$consistenHash->printCapacity();
echo PHP_EOL;
$consistenHash->printVirtNum();

echo PHP_EOL;
// 增加节点
$consistenHash->addNode('127.0.0.1:80');
$consistenHash->addNode('127.0.0.1:81');
$consistenHash->addNode('127.0.0.1:82');
$consistenHash->addNode('127.0.0.1:83');
$consistenHash->addNode('127.0.0.1:84');

echo PHP_EOL;
$consistenHash->printCircle();
echo PHP_EOL;

// 查找字符串哈希到的节点
var_dump('abc -> '.$consistenHash->lookup('abc'));
var_dump('def -> '.$consistenHash->lookup('def'));
var_dump('ghi -> '.$consistenHash->lookup('ghi'));
var_dump('gbi -> '.$consistenHash->lookup('gbi'));
var_dump('gmki -> '.$consistenHash->lookup('gmki'));
var_dump('aoki -> '.$consistenHash->lookup('aoki'));

echo "\n========\n\n";

// 删除某个节点
$consistenHash->removeNode('127.0.0.1:82');

// 再次查找节点
var_dump('abc -> '.$consistenHash->lookup('abc'));
var_dump('def -> '.$consistenHash->lookup('def'));
var_dump('ghi -> '.$consistenHash->lookup('ghi'));
var_dump('gbi -> '.$consistenHash->lookup('gbi'));
var_dump('gmki -> '.$consistenHash->lookup('gmki'));
var_dump('aoki -> '.$consistenHash->lookup('aoki'));