['pragma solidity ^0.4.4;\n', '\n', '// ## Mattew - a contract for increasing "whaleth"\n', '// README: https://github.com/rolandkofler/mattew\n', '// MIT LICENSE 2016 Roland Kofler, thanks to Crul for testing\n', '\n', 'contract Mattew {\n', '    address whale;\n', '    uint256 stake;\n', '    uint256 blockheight;\n', '    uint256 constant PERIOD = 200; //60 * 10 /14; //BLOCKS_PER_DAY;\n', '    uint constant DELTA = 0.1 ether;\n', '    \n', '    event MattewWon(string msg, address winner, uint value,  uint blocknumber);\n', '    event StakeIncreased(string msg, address staker, uint value, uint blocknumber);\n', '    \n', '    function Mattew(){\n', '        setFacts();\n', '    }\n', '    \n', '    function setFacts() private {\n', '        stake = msg.value;\n', '        blockheight = block.number;\n', '        whale = msg.sender;\n', '    }\n', '    \n', '    /// The rich get richer, the whale get whaler\n', '    function () payable{\n', '        if (block.number - PERIOD > blockheight){\n', '            bool isSuccess = whale.send(stake);\n', '            MattewWon("Mattew won (mattew, stake, blockheight)", whale, stake, block.number);\n', '            setFacts();\n', '            // selfdestruct(whale); People with Ethereum Foundation are ok with it.\n', '            return;\n', '            \n', '        }else{\n', '            \n', '            if (msg.value < stake + DELTA) throw;\n', '            bool isOtherSuccess = msg.sender.send(stake);\n', '            setFacts();\n', '            StakeIncreased("stake increased (whale, stake, blockheight)", whale, stake, blockheight);\n', '        }\n', '    }\n', '    \n', '    \n', '    function getStake() public constant returns(uint){\n', '        return stake;\n', '    }\n', '    \n', '    function getBlocksTillMattew() public constant returns(uint){\n', '        if (blockheight + PERIOD > block.number)\n', '            return blockheight + PERIOD - block.number;\n', '        else\n', '            return 0;\n', '    }\n', '}']