['pragma solidity ^0.4.11;\n', '\n', 'contract TwoUp {\n', '    // Punter who made the most recent bet\n', '    address public punterAddress;\n', '    // Amount of that most recent bet\n', '    uint256 public puntAmount;\n', '    // Is there someone waiting with a bet down?\n', '    bool public punterWaiting;\n', '\n', '    // Note the lack of owner privileges. The house gets nothing, like true blue\n', '    // Aussie two-up. Also this feels more legal idunno\n', '\n', "    // Don't let mad dogs bet more than 10 ether and don't let time wasters send\n", '    // empty transactions.\n', '    modifier withinRange {\n', '        assert(msg.value > 0 ether && msg.value < 10 ether);\n', '        _;\n', '    }\n', '    \n', '    // Initialise/Create Contract\n', '    function TwoUp() public {\n', '        punterWaiting = false;\n', '    }\n', '    \n', '    // Main Function. All action happens by users submitting a bet to the smart\n', '    // contract. No message is required, just a bet. If you bet more than your \n', '    // opponent then you will get the change sent back to you. If you bet less\n', '    // then they will get their change sent back to them. i.e. the actual wager\n', '    // amount is min(bet_1,bet_2).\n', '    function () payable public withinRange {\n', '        if (punterWaiting){\n', '            uint256 _payout = min(msg.value,puntAmount);\n', '            if (rand(punterAddress) >= rand(msg.sender)) {\n', '                punterAddress.transfer(_payout+puntAmount);\n', '                if ((msg.value-_payout)>0)\n', '                    msg.sender.transfer(msg.value-_payout);\n', '            } else {\n', '                msg.sender.transfer(_payout+msg.value);\n', '                if ((puntAmount-_payout)>0)\n', '                    punterAddress.transfer(puntAmount-_payout);\n', '            }\n', '            punterWaiting = false;\n', '        } else {\n', '            punterWaiting = true;\n', '            punterAddress = msg.sender;\n', '            puntAmount = msg.value;\n', '        }\n', '    }\n', '    \n', '    // min(a,b) function required for tidiness\n', '    function min(uint256 _a, uint256 _b) private pure returns(uint256){\n', '        if (_b < _a) {\n', '            return _b;\n', '        } else {\n', '            return _a;\n', '        }\n', '    }\n', '    function rand(address _who) private view returns(bytes32){\n', '        return keccak256(_who,now);\n', '    }\n', '    \n', '}']