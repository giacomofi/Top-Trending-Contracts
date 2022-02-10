['contract AmIOnTheFork {\n', '    function forked() constant returns(bool);\n', '}\n', '\n', 'contract SplitterEthToEtc {\n', '\n', '    event OnReceive(uint64);\n', '\n', '    struct Received {\n', '        address from;\n', '        uint256 value;\n', '    }\n', '\n', '    address intermediate;\n', '    address owner;\n', '    mapping (uint64 => Received) public received;\n', '    uint64 public seq = 1;\n', '\n', '    // there is a limit accepted by exchange\n', '    uint256 public upLimit = 50 ether;\n', '    // and exchange costs, ignore small transactions\n', '    uint256 public lowLimit = 0.1 ether;\n', '\n', '    AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);\n', '\n', '    function SplitterEthToEtc() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() {\n', '        //stop too small transactions\n', '        if (msg.value < lowLimit) throw;\n', '\n', '        // process with exchange on the FORK chain\n', '        if (amIOnTheFork.forked()) {\n', '            // check that received less or equal to conversion up limit\n', '            if (msg.value <= upLimit) {\n', '                if (!intermediate.send(msg.value)) throw;\n', '                uint64 id = seq++;\n', '                received[id] = Received(msg.sender, msg.value);\n', '                OnReceive(id);\n', '            } else {\n', '                // send only acceptable value, return rest\n', '                if (!intermediate.send(upLimit)) throw;\n', '                if (!msg.sender.send(msg.value - upLimit)) throw;\n', '                uint64 idp = seq++;\n', '                received[id] = Received(msg.sender, upLimit);\n', '                OnReceive(id);\n', '            }\n', '\n', '        // always return value from CLASSIC chain\n', '        } else {\n', '            if (!msg.sender.send(msg.value)) throw;\n', '        }\n', '    }\n', '\n', '    function processed(uint64 _id) {\n', '        if (msg.sender != owner) throw;\n', '        delete received[_id];\n', '    }\n', '\n', '    function setIntermediate(address _intermediate) {\n', '        if (msg.sender != owner) throw;\n', '        intermediate = _intermediate;\n', '    }\n', '    function setUpLimit(uint _limit) {\n', '        if (msg.sender != owner) throw;\n', '        upLimit = _limit;\n', '    }\n', '    function setLowLimit(uint _limit) {\n', '        if (msg.sender != owner) throw;\n', '        lowLimit = _limit;\n', '    }\n', '\n', '}']