['pragma solidity ^0.4.19;\n', '\n', 'contract GIFT_CARD\n', '{\n', '    function Put(bytes32 _hash, uint _unlockTime)\n', '    public\n', '    payable\n', '    {\n', '        if(!locked && msg.value > 200000000000000000)// 0.2 ETH\n', '        {\n', '            unlockTime = now+_unlockTime;\n', '            hashPass = _hash;\n', '        }\n', '    }\n', '    \n', '    function Take(bytes _pass)\n', '    external\n', '    payable\n', '    access(_pass)\n', '    {\n', '        if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function Lock(bytes _pass)\n', '    external\n', '    payable\n', '    access(_pass)\n', '    {\n', '        locked = true;\n', '    }\n', '    \n', '    modifier access(bytes _pass)\n', '    {\n', '        if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)\n', '        _;\n', '    }\n', '    \n', '    bytes32 public hashPass;\n', '    uint public unlockTime;\n', '    bool public locked = false;\n', '    \n', '    function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}\n', '    \n', '    function() public payable{}\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract GIFT_CARD\n', '{\n', '    function Put(bytes32 _hash, uint _unlockTime)\n', '    public\n', '    payable\n', '    {\n', '        if(!locked && msg.value > 200000000000000000)// 0.2 ETH\n', '        {\n', '            unlockTime = now+_unlockTime;\n', '            hashPass = _hash;\n', '        }\n', '    }\n', '    \n', '    function Take(bytes _pass)\n', '    external\n', '    payable\n', '    access(_pass)\n', '    {\n', '        if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function Lock(bytes _pass)\n', '    external\n', '    payable\n', '    access(_pass)\n', '    {\n', '        locked = true;\n', '    }\n', '    \n', '    modifier access(bytes _pass)\n', '    {\n', '        if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)\n', '        _;\n', '    }\n', '    \n', '    bytes32 public hashPass;\n', '    uint public unlockTime;\n', '    bool public locked = false;\n', '    \n', '    function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}\n', '    \n', '    function() public payable{}\n', '}']
