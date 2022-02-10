['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * An interface providing the necessary Beercoin functionality\n', ' */\n', 'interface Beercoin {\n', '    function transfer(address _to, uint256 _amount) external;\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function decimals() external pure returns (uint8);\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines owner and guardians of the ICO\n', ' */\n', 'contract GuardedBeercoinICO {\n', '    address public owner;\n', '\n', '    address public constant guardian1 = 0x7d54aD7DA2DE1FD3241e1c5e8B5Ac9ACF435070A;\n', '    address public constant guardian2 = 0x065a6D3c1986E608354A8e7626923816734fc468;\n', '    address public constant guardian3 = 0x1c387D6FDCEF351Fc0aF5c7cE6970274489b244B;\n', '\n', '    address public guardian1Vote = 0x0;\n', '    address public guardian2Vote = 0x0;\n', '    address public guardian3Vote = 0x0;\n', '\n', '    /**\n', '     * Restrict to the owner only\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to guardians only\n', '     */\n', '    modifier onlyGuardian() {\n', '        require(msg.sender == guardian1 || msg.sender == guardian2 || msg.sender == guardian3);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Construct the GuardedBeercoinICO contract\n', '     * and make the sender the owner\n', '     */\n', '    function GuardedBeercoinICO() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Declare a new owner\n', '     *\n', '     * @param newOwner the new owner&#39;s address\n', '     */\n', '    function setOwner(address newOwner) onlyGuardian public {\n', '        if (msg.sender == guardian1) {\n', '            if (newOwner == guardian2Vote || newOwner == guardian3Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian1Vote = newOwner;\n', '            }\n', '        } else if (msg.sender == guardian2) {\n', '            if (newOwner == guardian1Vote || newOwner == guardian3Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian2Vote = newOwner;\n', '            }\n', '        } else if (msg.sender == guardian3) {\n', '            if (newOwner == guardian1Vote || newOwner == guardian2Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian3Vote = newOwner;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines the Beercoin ICO\n', ' */\n', 'contract BeercoinICO is GuardedBeercoinICO {\n', '    Beercoin internal beercoin = Beercoin(0x7367A68039d4704f30BfBF6d948020C3B07DFC59);\n', '\n', '    uint public constant price = 0.000006 ether;\n', '    uint public constant softCap = 48 ether;\n', '    uint public constant begin = 1526637600; // 2018-05-18 12:00:00 (UTC+01:00)\n', '    uint public constant end = 1530395999;   // 2018-06-30 23:59:59 (UTC+01:00)\n', '    \n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '   \n', '    mapping(address => uint256) public balanceOf;\n', '    uint public soldBeercoins = 0;\n', '    uint public raisedEther = 0 ether;\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * Restrict to the time when the ICO is open\n', '     */\n', '    modifier isOpen {\n', '        require(now >= begin && now <= end && !paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to the state of enough Ether being gathered\n', '     */\n', '    modifier goalReached {\n', '        require(raisedEther >= softCap);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to the state of not enough Ether\n', '     * being gathered after the time is up\n', '     */\n', '    modifier goalNotReached {\n', '        require(raisedEther < softCap && now > end);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins to a user who sent Ether to this contract\n', '     */\n', '    function() payable isOpen public {\n', '        uint etherAmount = msg.value;\n', '        balanceOf[msg.sender] += etherAmount;\n', '\n', '        uint beercoinAmount = (etherAmount * 10**uint(beercoin.decimals())) / price;\n', '        beercoin.transfer(msg.sender, beercoinAmount);\n', '\n', '        soldBeercoins += beercoinAmount;        \n', '        raisedEther += etherAmount;\n', '        emit FundTransfer(msg.sender, etherAmount, true);\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins to a user who purchased via other payment methods\n', '     *\n', '     * @param to the address of the recipient\n', '     * @param beercoinAmount the amount of Beercoins to send\n', '     */\n', '    function transfer(address to, uint beercoinAmount) isOpen onlyOwner public {        \n', '        beercoin.transfer(to, beercoinAmount);\n', '\n', '        uint etherAmount = beercoinAmount * price;        \n', '        raisedEther += etherAmount;\n', '\n', '        emit FundTransfer(msg.sender, etherAmount, true);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the sender&#39;s contributed Ether in case the goal has not been reached\n', '     */\n', '    function withdraw() goalNotReached public {\n', '        uint amount = balanceOf[msg.sender];\n', '        require(amount > 0);\n', '\n', '        balanceOf[msg.sender] = 0;\n', '        msg.sender.transfer(amount);\n', '\n', '        emit FundTransfer(msg.sender, amount, false);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the contributed Ether stored in this contract\n', '     * if the funding goal has been reached.\n', '     */\n', '    function claimFunds() onlyOwner goalReached public {\n', '        uint etherAmount = address(this).balance;\n', '        owner.transfer(etherAmount);\n', '\n', '        emit FundTransfer(owner, etherAmount, false);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the remaining Beercoins in this contract\n', '     */\n', '    function claimBeercoins() onlyOwner public {\n', '        uint beercoinAmount = beercoin.balanceOf(address(this));\n', '        beercoin.transfer(owner, beercoinAmount);\n', '    }\n', '\n', '    /**\n', '     * Pause the token sale\n', '     */\n', '    function pause() onlyOwner public {\n', '        paused = true;\n', '    }\n', '\n', '    /**\n', '     * Resume the token sale\n', '     */\n', '    function resume() onlyOwner public {\n', '        paused = false;\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * An interface providing the necessary Beercoin functionality\n', ' */\n', 'interface Beercoin {\n', '    function transfer(address _to, uint256 _amount) external;\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function decimals() external pure returns (uint8);\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines owner and guardians of the ICO\n', ' */\n', 'contract GuardedBeercoinICO {\n', '    address public owner;\n', '\n', '    address public constant guardian1 = 0x7d54aD7DA2DE1FD3241e1c5e8B5Ac9ACF435070A;\n', '    address public constant guardian2 = 0x065a6D3c1986E608354A8e7626923816734fc468;\n', '    address public constant guardian3 = 0x1c387D6FDCEF351Fc0aF5c7cE6970274489b244B;\n', '\n', '    address public guardian1Vote = 0x0;\n', '    address public guardian2Vote = 0x0;\n', '    address public guardian3Vote = 0x0;\n', '\n', '    /**\n', '     * Restrict to the owner only\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to guardians only\n', '     */\n', '    modifier onlyGuardian() {\n', '        require(msg.sender == guardian1 || msg.sender == guardian2 || msg.sender == guardian3);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Construct the GuardedBeercoinICO contract\n', '     * and make the sender the owner\n', '     */\n', '    function GuardedBeercoinICO() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Declare a new owner\n', '     *\n', "     * @param newOwner the new owner's address\n", '     */\n', '    function setOwner(address newOwner) onlyGuardian public {\n', '        if (msg.sender == guardian1) {\n', '            if (newOwner == guardian2Vote || newOwner == guardian3Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian1Vote = newOwner;\n', '            }\n', '        } else if (msg.sender == guardian2) {\n', '            if (newOwner == guardian1Vote || newOwner == guardian3Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian2Vote = newOwner;\n', '            }\n', '        } else if (msg.sender == guardian3) {\n', '            if (newOwner == guardian1Vote || newOwner == guardian2Vote) {\n', '                owner = newOwner;\n', '                guardian1Vote = 0x0;\n', '                guardian2Vote = 0x0;\n', '                guardian3Vote = 0x0;\n', '            } else {\n', '                guardian3Vote = newOwner;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines the Beercoin ICO\n', ' */\n', 'contract BeercoinICO is GuardedBeercoinICO {\n', '    Beercoin internal beercoin = Beercoin(0x7367A68039d4704f30BfBF6d948020C3B07DFC59);\n', '\n', '    uint public constant price = 0.000006 ether;\n', '    uint public constant softCap = 48 ether;\n', '    uint public constant begin = 1526637600; // 2018-05-18 12:00:00 (UTC+01:00)\n', '    uint public constant end = 1530395999;   // 2018-06-30 23:59:59 (UTC+01:00)\n', '    \n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '   \n', '    mapping(address => uint256) public balanceOf;\n', '    uint public soldBeercoins = 0;\n', '    uint public raisedEther = 0 ether;\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * Restrict to the time when the ICO is open\n', '     */\n', '    modifier isOpen {\n', '        require(now >= begin && now <= end && !paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to the state of enough Ether being gathered\n', '     */\n', '    modifier goalReached {\n', '        require(raisedEther >= softCap);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Restrict to the state of not enough Ether\n', '     * being gathered after the time is up\n', '     */\n', '    modifier goalNotReached {\n', '        require(raisedEther < softCap && now > end);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins to a user who sent Ether to this contract\n', '     */\n', '    function() payable isOpen public {\n', '        uint etherAmount = msg.value;\n', '        balanceOf[msg.sender] += etherAmount;\n', '\n', '        uint beercoinAmount = (etherAmount * 10**uint(beercoin.decimals())) / price;\n', '        beercoin.transfer(msg.sender, beercoinAmount);\n', '\n', '        soldBeercoins += beercoinAmount;        \n', '        raisedEther += etherAmount;\n', '        emit FundTransfer(msg.sender, etherAmount, true);\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins to a user who purchased via other payment methods\n', '     *\n', '     * @param to the address of the recipient\n', '     * @param beercoinAmount the amount of Beercoins to send\n', '     */\n', '    function transfer(address to, uint beercoinAmount) isOpen onlyOwner public {        \n', '        beercoin.transfer(to, beercoinAmount);\n', '\n', '        uint etherAmount = beercoinAmount * price;        \n', '        raisedEther += etherAmount;\n', '\n', '        emit FundTransfer(msg.sender, etherAmount, true);\n', '    }\n', '\n', '    /**\n', "     * Withdraw the sender's contributed Ether in case the goal has not been reached\n", '     */\n', '    function withdraw() goalNotReached public {\n', '        uint amount = balanceOf[msg.sender];\n', '        require(amount > 0);\n', '\n', '        balanceOf[msg.sender] = 0;\n', '        msg.sender.transfer(amount);\n', '\n', '        emit FundTransfer(msg.sender, amount, false);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the contributed Ether stored in this contract\n', '     * if the funding goal has been reached.\n', '     */\n', '    function claimFunds() onlyOwner goalReached public {\n', '        uint etherAmount = address(this).balance;\n', '        owner.transfer(etherAmount);\n', '\n', '        emit FundTransfer(owner, etherAmount, false);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the remaining Beercoins in this contract\n', '     */\n', '    function claimBeercoins() onlyOwner public {\n', '        uint beercoinAmount = beercoin.balanceOf(address(this));\n', '        beercoin.transfer(owner, beercoinAmount);\n', '    }\n', '\n', '    /**\n', '     * Pause the token sale\n', '     */\n', '    function pause() onlyOwner public {\n', '        paused = true;\n', '    }\n', '\n', '    /**\n', '     * Resume the token sale\n', '     */\n', '    function resume() onlyOwner public {\n', '        paused = false;\n', '    }\n', '}']