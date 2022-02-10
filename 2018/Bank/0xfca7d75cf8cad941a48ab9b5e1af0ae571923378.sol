['pragma solidity ^0.4.20;\n', '\n', 'contract Gladiethers\n', '{\n', '    address public m_Owner;\n', '    address public partner;\n', '\n', '    mapping (address => uint) public gladiatorToPower; // gladiator power\n', '    mapping (address => uint) public gladiatorToCooldown;\n', '    mapping(address => uint) public gladiatorToQueuePosition;\n', '    mapping(address => bool)  public trustedContracts;\n', '    uint public m_OwnerFees = 0;\n', '    address public kingGladiator;\n', '    address public oraclizeContract;\n', '    address[] public queue;\n', '    \n', '    bool started = false;\n', '\n', '\n', '    event fightEvent(address indexed g1,address indexed g2,uint random,uint fightPower,uint g1Power);\n', '    modifier OnlyOwnerAndContracts() {\n', '        require(msg.sender == m_Owner ||  trustedContracts[msg.sender]);\n', '        _;\n', '    }\n', '    function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts() {\n', '        require(msg.sender != contract_address);\n', '        trustedContracts[contract_address] = trust_flag;\n', '    }\n', '    \n', '    function Gladiethers() public{\n', '        m_Owner = msg.sender;\n', '    }\n', '    \n', '    function setPartner(address contract_partner) public OnlyOwnerAndContracts(){\n', '        partner = contract_partner;\n', '    }\n', '    \n', '    function setOraclize(address contract_oraclize) public OnlyOwnerAndContracts(){\n', '        require(!started);\n', '        oraclizeContract = contract_oraclize;\n', '        started = true;\n', '    }\n', '\n', '    function joinArena() public payable returns (bool){\n', '\n', '        require( msg.value >= 10 finney );\n', '\n', '        if(queue.length > gladiatorToQueuePosition[msg.sender]){\n', '\n', '            if(queue[gladiatorToQueuePosition[msg.sender]] == msg.sender){\n', '                gladiatorToPower[msg.sender] += msg.value;\n', '                return false;\n', '            }\n', '        }\n', '        \n', '        enter(msg.sender);\n', '        return true;  \n', '\n', '    }\n', '\n', '    function enter(address gladiator) private{\n', '        gladiatorToCooldown[gladiator] = now + 1 days;\n', '        queue.push(gladiator);\n', '        gladiatorToQueuePosition[gladiator] = queue.length - 1;\n', '        gladiatorToPower[gladiator] += msg.value;\n', '    }\n', '\n', '\n', '    function remove(address gladiator) private returns(bool){\n', '        \n', '        if(queue.length > gladiatorToQueuePosition[gladiator]){\n', '\n', '            if(queue[gladiatorToQueuePosition[gladiator]] == gladiator){ // is on the line ?\n', '            \n', '                queue[gladiatorToQueuePosition[gladiator]] = queue[queue.length - 1];\n', '                gladiatorToQueuePosition[queue[queue.length - 1]] = gladiatorToQueuePosition[gladiator];\n', '                gladiatorToCooldown[gladiator] =  9999999999999; // indicative number to know when it is in battle\n', '                delete queue[queue.length - 1];\n', '                queue.length = queue.length - (1);\n', '                return true;\n', '                \n', '            }\n', '           \n', '        }\n', '        return false;\n', '        \n', '        \n', '    }\n', '\n', '    function removeOrc(address _gladiator) public {\n', '        require(msg.sender == oraclizeContract);\n', '        remove(_gladiator);\n', '    }\n', '\n', '    function setCooldown(address gladiator, uint cooldown) internal{\n', '        gladiatorToCooldown[gladiator] = cooldown;\n', '    }\n', '\n', '    function getGladiatorPower(address gladiator) public view returns (uint){\n', '        return gladiatorToPower[gladiator];\n', '    }\n', '    \n', '    function getQueueLenght() public view returns (uint){\n', '        return queue.length;\n', '    }\n', '\n', '    function fight(address gladiator1,string _result) public {\n', '\n', '        require(msg.sender == oraclizeContract);\n', '        \n', '        // in a unlikely case of 3 guys in queue two of them scheduleFight and the last one withdraws and left the first fighter that enconters the queue empty becomes the kingGladiator\n', '        if(queue.length == 0){  \n', '            gladiatorToCooldown[gladiator1] = now + 1 days;\n', '            queue.push(gladiator1);\n', '            gladiatorToQueuePosition[gladiator1] = queue.length - 1;\n', '            kingGladiator = gladiator1;\n', '        }else{\n', '        \n', '            uint indexgladiator2 = uint(sha3(_result)) % queue.length; // this is an efficient way to get the uint out in the [0, maxRange] range\n', '            uint randomNumber = uint(sha3(_result)) % 1000;\n', '            address gladiator2 = queue[indexgladiator2];\n', '            \n', '            require(gladiatorToPower[gladiator1] >= 10 finney && gladiator1 != gladiator2);\n', '    \n', '            \n', '            uint g1chance = gladiatorToPower[gladiator1];\n', '            uint g2chance =  gladiatorToPower[gladiator2];\n', '            uint fightPower = SafeMath.add(g1chance,g2chance);\n', '    \n', '            g1chance = (g1chance*1000)/fightPower;\n', '    \n', '            if(g1chance <= 958){\n', '                g1chance = SafeMath.add(g1chance,40);\n', '            }else{\n', '                g1chance = 998;\n', '            }\n', '    \n', '            fightEvent( gladiator1, gladiator2,randomNumber,fightPower,gladiatorToPower[gladiator1]);\n', '            uint devFee;\n', '    \n', '            if(randomNumber <= g1chance ){ // Wins the Attacker\n', '                devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator2],4),100);\n', '    \n', '                gladiatorToPower[gladiator1] =  SafeMath.add( gladiatorToPower[gladiator1], SafeMath.sub(gladiatorToPower[gladiator2],devFee) );\n', '                queue[gladiatorToQueuePosition[gladiator2]] = gladiator1;\n', '                gladiatorToQueuePosition[gladiator1] = gladiatorToQueuePosition[gladiator2];\n', '                gladiatorToPower[gladiator2] = 0;\n', '                gladiatorToCooldown[gladiator1] = now + 1 days; // reset atacker cooldown\n', '    \n', '                if(gladiatorToPower[gladiator1] > gladiatorToPower[kingGladiator] ){ // check if is the biggest guy in the arena\n', '                    kingGladiator = gladiator1;\n', '                }\n', '    \n', '            }else{\n', '                //Defender Wins\n', '                devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator1],4),100);\n', '    \n', '                gladiatorToPower[gladiator2] = SafeMath.add( gladiatorToPower[gladiator2],SafeMath.sub(gladiatorToPower[gladiator1],devFee) );\n', '                gladiatorToPower[gladiator1] = 0;\n', '    \n', '                if(gladiatorToPower[gladiator2] > gladiatorToPower[kingGladiator] ){\n', '                    kingGladiator = gladiator2;\n', '                }\n', '\n', '        }\n', '\n', '        \n', '        gladiatorToPower[kingGladiator] = SafeMath.add( gladiatorToPower[kingGladiator],SafeMath.div(devFee,4) ); // gives 1%      (4% dead gladiator / 4 )\n', '        m_OwnerFees = SafeMath.add( m_OwnerFees , SafeMath.sub(devFee,SafeMath.div(devFee,4)) ); // 4total - 1king  = 3%\n', '        }\n', '        \n', '        \n', '\n', '    }\n', '\n', '\n', '    function withdraw(uint amount) public  returns (bool success){\n', '        address withdrawalAccount;\n', '        uint withdrawalAmount;\n', '\n', '        // owner and partner can withdraw\n', '        if (msg.sender == m_Owner || msg.sender == partner ) {\n', '            withdrawalAccount = m_Owner;\n', '            withdrawalAmount = m_OwnerFees;\n', '            uint partnerFee = SafeMath.div(SafeMath.mul(withdrawalAmount,15),100);\n', '\n', '            // set funds to 0\n', '            m_OwnerFees = 0;\n', '\n', '            if (!m_Owner.send(SafeMath.sub(withdrawalAmount,partnerFee))) revert(); // send to owner\n', '            if (!partner.send(partnerFee)) revert(); // send to partner\n', '\n', '            return true;\n', '        }else{\n', '\n', '            withdrawalAccount = msg.sender;\n', '            withdrawalAmount = amount;\n', '\n', '            // cooldown has been reached and the ammout i possible\n', '            if(gladiatorToCooldown[msg.sender] < now && gladiatorToPower[withdrawalAccount] >= withdrawalAmount){\n', '\n', '                gladiatorToPower[withdrawalAccount] = SafeMath.sub(gladiatorToPower[withdrawalAccount],withdrawalAmount);\n', '\n', '                // gladiator have to be removed from areana if the power is less then 0.01 eth\n', '                if(gladiatorToPower[withdrawalAccount] < 10 finney){\n', '                    remove(msg.sender);\n', '                }\n', '\n', '            }else{\n', '                return false;\n', '            }\n', '\n', '        }\n', '\n', '        if (withdrawalAmount == 0) revert();\n', '\n', '        // send the funds\n', '        if (!msg.sender.send(withdrawalAmount)) revert();\n', '\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract Gladiethers\n', '{\n', '    address public m_Owner;\n', '    address public partner;\n', '\n', '    mapping (address => uint) public gladiatorToPower; // gladiator power\n', '    mapping (address => uint) public gladiatorToCooldown;\n', '    mapping(address => uint) public gladiatorToQueuePosition;\n', '    mapping(address => bool)  public trustedContracts;\n', '    uint public m_OwnerFees = 0;\n', '    address public kingGladiator;\n', '    address public oraclizeContract;\n', '    address[] public queue;\n', '    \n', '    bool started = false;\n', '\n', '\n', '    event fightEvent(address indexed g1,address indexed g2,uint random,uint fightPower,uint g1Power);\n', '    modifier OnlyOwnerAndContracts() {\n', '        require(msg.sender == m_Owner ||  trustedContracts[msg.sender]);\n', '        _;\n', '    }\n', '    function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts() {\n', '        require(msg.sender != contract_address);\n', '        trustedContracts[contract_address] = trust_flag;\n', '    }\n', '    \n', '    function Gladiethers() public{\n', '        m_Owner = msg.sender;\n', '    }\n', '    \n', '    function setPartner(address contract_partner) public OnlyOwnerAndContracts(){\n', '        partner = contract_partner;\n', '    }\n', '    \n', '    function setOraclize(address contract_oraclize) public OnlyOwnerAndContracts(){\n', '        require(!started);\n', '        oraclizeContract = contract_oraclize;\n', '        started = true;\n', '    }\n', '\n', '    function joinArena() public payable returns (bool){\n', '\n', '        require( msg.value >= 10 finney );\n', '\n', '        if(queue.length > gladiatorToQueuePosition[msg.sender]){\n', '\n', '            if(queue[gladiatorToQueuePosition[msg.sender]] == msg.sender){\n', '                gladiatorToPower[msg.sender] += msg.value;\n', '                return false;\n', '            }\n', '        }\n', '        \n', '        enter(msg.sender);\n', '        return true;  \n', '\n', '    }\n', '\n', '    function enter(address gladiator) private{\n', '        gladiatorToCooldown[gladiator] = now + 1 days;\n', '        queue.push(gladiator);\n', '        gladiatorToQueuePosition[gladiator] = queue.length - 1;\n', '        gladiatorToPower[gladiator] += msg.value;\n', '    }\n', '\n', '\n', '    function remove(address gladiator) private returns(bool){\n', '        \n', '        if(queue.length > gladiatorToQueuePosition[gladiator]){\n', '\n', '            if(queue[gladiatorToQueuePosition[gladiator]] == gladiator){ // is on the line ?\n', '            \n', '                queue[gladiatorToQueuePosition[gladiator]] = queue[queue.length - 1];\n', '                gladiatorToQueuePosition[queue[queue.length - 1]] = gladiatorToQueuePosition[gladiator];\n', '                gladiatorToCooldown[gladiator] =  9999999999999; // indicative number to know when it is in battle\n', '                delete queue[queue.length - 1];\n', '                queue.length = queue.length - (1);\n', '                return true;\n', '                \n', '            }\n', '           \n', '        }\n', '        return false;\n', '        \n', '        \n', '    }\n', '\n', '    function removeOrc(address _gladiator) public {\n', '        require(msg.sender == oraclizeContract);\n', '        remove(_gladiator);\n', '    }\n', '\n', '    function setCooldown(address gladiator, uint cooldown) internal{\n', '        gladiatorToCooldown[gladiator] = cooldown;\n', '    }\n', '\n', '    function getGladiatorPower(address gladiator) public view returns (uint){\n', '        return gladiatorToPower[gladiator];\n', '    }\n', '    \n', '    function getQueueLenght() public view returns (uint){\n', '        return queue.length;\n', '    }\n', '\n', '    function fight(address gladiator1,string _result) public {\n', '\n', '        require(msg.sender == oraclizeContract);\n', '        \n', '        // in a unlikely case of 3 guys in queue two of them scheduleFight and the last one withdraws and left the first fighter that enconters the queue empty becomes the kingGladiator\n', '        if(queue.length == 0){  \n', '            gladiatorToCooldown[gladiator1] = now + 1 days;\n', '            queue.push(gladiator1);\n', '            gladiatorToQueuePosition[gladiator1] = queue.length - 1;\n', '            kingGladiator = gladiator1;\n', '        }else{\n', '        \n', '            uint indexgladiator2 = uint(sha3(_result)) % queue.length; // this is an efficient way to get the uint out in the [0, maxRange] range\n', '            uint randomNumber = uint(sha3(_result)) % 1000;\n', '            address gladiator2 = queue[indexgladiator2];\n', '            \n', '            require(gladiatorToPower[gladiator1] >= 10 finney && gladiator1 != gladiator2);\n', '    \n', '            \n', '            uint g1chance = gladiatorToPower[gladiator1];\n', '            uint g2chance =  gladiatorToPower[gladiator2];\n', '            uint fightPower = SafeMath.add(g1chance,g2chance);\n', '    \n', '            g1chance = (g1chance*1000)/fightPower;\n', '    \n', '            if(g1chance <= 958){\n', '                g1chance = SafeMath.add(g1chance,40);\n', '            }else{\n', '                g1chance = 998;\n', '            }\n', '    \n', '            fightEvent( gladiator1, gladiator2,randomNumber,fightPower,gladiatorToPower[gladiator1]);\n', '            uint devFee;\n', '    \n', '            if(randomNumber <= g1chance ){ // Wins the Attacker\n', '                devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator2],4),100);\n', '    \n', '                gladiatorToPower[gladiator1] =  SafeMath.add( gladiatorToPower[gladiator1], SafeMath.sub(gladiatorToPower[gladiator2],devFee) );\n', '                queue[gladiatorToQueuePosition[gladiator2]] = gladiator1;\n', '                gladiatorToQueuePosition[gladiator1] = gladiatorToQueuePosition[gladiator2];\n', '                gladiatorToPower[gladiator2] = 0;\n', '                gladiatorToCooldown[gladiator1] = now + 1 days; // reset atacker cooldown\n', '    \n', '                if(gladiatorToPower[gladiator1] > gladiatorToPower[kingGladiator] ){ // check if is the biggest guy in the arena\n', '                    kingGladiator = gladiator1;\n', '                }\n', '    \n', '            }else{\n', '                //Defender Wins\n', '                devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator1],4),100);\n', '    \n', '                gladiatorToPower[gladiator2] = SafeMath.add( gladiatorToPower[gladiator2],SafeMath.sub(gladiatorToPower[gladiator1],devFee) );\n', '                gladiatorToPower[gladiator1] = 0;\n', '    \n', '                if(gladiatorToPower[gladiator2] > gladiatorToPower[kingGladiator] ){\n', '                    kingGladiator = gladiator2;\n', '                }\n', '\n', '        }\n', '\n', '        \n', '        gladiatorToPower[kingGladiator] = SafeMath.add( gladiatorToPower[kingGladiator],SafeMath.div(devFee,4) ); // gives 1%      (4% dead gladiator / 4 )\n', '        m_OwnerFees = SafeMath.add( m_OwnerFees , SafeMath.sub(devFee,SafeMath.div(devFee,4)) ); // 4total - 1king  = 3%\n', '        }\n', '        \n', '        \n', '\n', '    }\n', '\n', '\n', '    function withdraw(uint amount) public  returns (bool success){\n', '        address withdrawalAccount;\n', '        uint withdrawalAmount;\n', '\n', '        // owner and partner can withdraw\n', '        if (msg.sender == m_Owner || msg.sender == partner ) {\n', '            withdrawalAccount = m_Owner;\n', '            withdrawalAmount = m_OwnerFees;\n', '            uint partnerFee = SafeMath.div(SafeMath.mul(withdrawalAmount,15),100);\n', '\n', '            // set funds to 0\n', '            m_OwnerFees = 0;\n', '\n', '            if (!m_Owner.send(SafeMath.sub(withdrawalAmount,partnerFee))) revert(); // send to owner\n', '            if (!partner.send(partnerFee)) revert(); // send to partner\n', '\n', '            return true;\n', '        }else{\n', '\n', '            withdrawalAccount = msg.sender;\n', '            withdrawalAmount = amount;\n', '\n', '            // cooldown has been reached and the ammout i possible\n', '            if(gladiatorToCooldown[msg.sender] < now && gladiatorToPower[withdrawalAccount] >= withdrawalAmount){\n', '\n', '                gladiatorToPower[withdrawalAccount] = SafeMath.sub(gladiatorToPower[withdrawalAccount],withdrawalAmount);\n', '\n', '                // gladiator have to be removed from areana if the power is less then 0.01 eth\n', '                if(gladiatorToPower[withdrawalAccount] < 10 finney){\n', '                    remove(msg.sender);\n', '                }\n', '\n', '            }else{\n', '                return false;\n', '            }\n', '\n', '        }\n', '\n', '        if (withdrawalAmount == 0) revert();\n', '\n', '        // send the funds\n', '        if (!msg.sender.send(withdrawalAmount)) revert();\n', '\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
