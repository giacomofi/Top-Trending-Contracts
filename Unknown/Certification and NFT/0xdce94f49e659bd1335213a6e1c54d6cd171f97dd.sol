['pragma solidity ^ 0.4 .6;\n', '\n', 'contract Campaign {\n', '\n', '        address public JohanNygren;\n', '        bool public campaignOpen;\n', '\n', '        function Campaign() {\n', '                JohanNygren = 0x948176cb42b65d835ee4324914b104b66fb93b52;\n', '                campaignOpen = true;\n', '        }\n', '\n', '        modifier onlyJohan {\n', '                if (msg.sender != JohanNygren) throw;\n', '                _;\n', '        }\n', '\n', '        modifier isOpen {\n', '                if (campaignOpen != true) throw;\n', '                _;\n', '        }\n', '\n', '        function closeCampaign() onlyJohan {\n', '                campaignOpen = false;\n', '        }\n', '\n', '}\n', '\n', '\n', '\n', 'contract RES is Campaign {\n', '\n', '        /* Public variables of the token */\n', '        string public name;\n', '        string public symbol;\n', '        uint8 public decimals;\n', '\n', '        uint public totalSupply;\n', '\n', '        /* This creates an array with all balances */\n', '        mapping(address => uint256) public balanceOf;\n', '\n', '        /* This generates a public event on the blockchain that will notify clients */\n', '        event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '        /* Bought or sold */\n', '\n', '        event Bought(address from, uint amount);\n', '        event Sold(address from, uint amount);\n', '\n', '        /* Initializes contract with name, symbol and decimals */\n', '\n', '        function RES() {\n', '                name = "RES";\n', '                symbol = "RES";\n', '                decimals = 18;\n', '        }\n', '\n', '        function buy() isOpen public payable {\n', '                balanceOf[msg.sender] += msg.value;\n', '                totalSupply += msg.value;\n', '                Bought(msg.sender, msg.value);\n', '        }\n', '\n', '        function sell(uint256 _value) public {\n', '                if (balanceOf[msg.sender] < _value) throw;\n', '                balanceOf[msg.sender] -= _value;\n', '\n', '                if (!msg.sender.send(_value)) throw;\n', '\n', '                totalSupply -= _value;\n', '                Sold(msg.sender, _value);\n', '\n', '        }\n', '\n', '}\n', '\n', 'contract SwarmRedistribution is Campaign, RES {\n', '\n', '        struct dividendPathway {\n', '                address from;\n', '                uint amount;\n', '                uint timeStamp;\n', '        }\n', '\n', '        mapping(address => dividendPathway[]) public dividendPathways;\n', '\n', '        mapping(address => bool) public isHuman;\n', '\n', '        mapping(address => uint256) public totalBasicIncome;\n', '\n', '        uint taxRate;\n', '        uint exchangeRate;\n', '\n', '        address[] humans;\n', '        mapping(address => bool) inHumans;\n', '\n', '        event Swarm(address indexed leaf, address indexed node, uint256 share);\n', '\n', '        function SwarmRedistribution() {\n', '\n', '                /* Tax-rate in parts per thousand */\n', '                taxRate = 20;\n', '\n', '                /* Exchange-rate in parts per thousand */\n', '                exchangeRate = 0;\n', '\n', '        }\n', '\n', '        /* Send coins */\n', '        function transfer(address _to, uint256 _value) isOpen {\n', '                /* reject transaction to self to prevent dividend pathway loops*/\n', '                if (_to == msg.sender) throw;\n', '\n', '                /* if the sender doenst have enough balance then stop */\n', '                if (balanceOf[msg.sender] < _value) throw;\n', '                if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '\n', '                /* Calculate tax */\n', '                uint256 taxCollected = _value * taxRate / 1000;\n', '                uint256 sentAmount;\n', '\n', '                /* Create the dividend pathway */\n', '                dividendPathways[_to].push(dividendPathway({\n', '                        from: msg.sender,\n', '                        amount: _value,\n', '                        timeStamp: now\n', '                }));\n', '\n', '                iterateThroughSwarm(_to, now, taxCollected);\n', '\n', '                if (humans.length > 0) {\n', '                        doSwarm(_to, taxCollected);\n', '                        sentAmount = _value;\n', '                } else sentAmount = _value - taxCollected; /* Return tax */\n', '\n', '\n', '                /* Add and subtract new balances */\n', '\n', '                balanceOf[msg.sender] -= sentAmount;\n', '                balanceOf[_to] += _value - taxCollected;\n', '\n', '                /* Notifiy anyone listening that this transfer took place */\n', '                Transfer(msg.sender, _to, sentAmount);\n', '        }\n', '\n', '\n', '        function iterateThroughSwarm(address _node, uint _timeStamp, uint _taxCollected) internal {\n', '                for (uint i = 0; i < dividendPathways[_node].length; i++) {\n', '\n', '                        uint timeStamp = dividendPathways[_node][i].timeStamp;\n', '                        if (timeStamp <= _timeStamp) {\n', '\n', '                                address node = dividendPathways[_node][i].from;\n', '\n', '                                if (\n', '                                        isHuman[node] == true &&\n', '                                        inHumans[node] == false\n', '                                ) {\n', '                                        humans.push(node);\n', '                                        inHumans[node] = true;\n', '                                }\n', '\n', '                                if (dividendPathways[_node][i].amount - _taxCollected > 0) {\n', '                                        dividendPathways[_node][i].amount -= _taxCollected;\n', '                                } else removeDividendPathway(_node, i);\n', '\n', '                                iterateThroughSwarm(node, timeStamp, _taxCollected);\n', '                        }\n', '                }\n', '        }\n', '\n', '        function doSwarm(address _leaf, uint256 _taxCollected) internal {\n', '\n', '                uint256 share = _taxCollected / humans.length;\n', '\n', '                for (uint i = 0; i < humans.length; i++) {\n', '\n', '                        balanceOf[humans[i]] += share;\n', '                        totalBasicIncome[humans[i]] += share;\n', '\n', '                        inHumans[humans[i]] = false;\n', '\n', '                        /* Notifiy anyone listening that this swarm took place */\n', '                        Swarm(_leaf, humans[i], share);\n', '                }\n', '                delete humans;\n', '        }\n', '\n', '        function removeDividendPathway(address node, uint index) internal {\n', '                delete dividendPathways[node][index];\n', '                for (uint i = index; i < dividendPathways[node].length - 1; i++) {\n', '                        dividendPathways[node][i] = dividendPathways[node][i + 1];\n', '                }\n', '                dividendPathways[node].length--;\n', '        }\n', '\n', '}\n', '\n', 'contract CampaignBeneficiary is Campaign, RES, SwarmRedistribution {\n', '\n', '        event BuyWithPathwayFromBeneficiary(address from, uint amount);\n', '\n', '        function CampaignBeneficiary() {\n', '                isHuman[JohanNygren] = true;\n', '        }\n', '\n', '        function simulatePathwayFromBeneficiary() isOpen public payable {\n', '                balanceOf[msg.sender] += msg.value;\n', '                totalSupply += msg.value;\n', '\n', '                /* Create the dividend pathway */\n', '                dividendPathways[msg.sender].push(dividendPathway({\n', '                        from: JohanNygren,\n', '                        amount: msg.value,\n', '                        timeStamp: now\n', '                }));\n', '\n', '                BuyWithPathwayFromBeneficiary(msg.sender, msg.value);\n', '        }\n', '\n', '}']