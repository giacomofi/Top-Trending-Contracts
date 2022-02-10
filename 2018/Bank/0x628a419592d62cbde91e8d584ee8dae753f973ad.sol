['pragma solidity ^0.4.25;\n', '// First Spielley and Dav collab on creating a Hot potato take for P3D\n', '// pass the spud, \n', '// each time you have the spud you can win the jackpot, \n', '// first player has most chance of hitting jackpot and slowly the chances of winning decrease. \n', '// if someone doesn&#39;t take over the spud within 256 blocks you auto win\n', '// each time you play you get a spudcoin\n', '// spudcoin reward for UI devs\n', '// spudcoins can be traded in for a part of the contracts divs\n', '// dependant on totalsupply and how many coins you trade in\n', '// you can also trade in spudcoin for spots in the MN rotator when the contract buys P3D\n', '// \n', '\n', 'contract Spud3D {\n', '    using SafeMath for uint;\n', '    \n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', '    SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//spielley&#39;s profit sharing payout\n', '    \n', '    struct State {\n', '        \n', '        uint256 blocknumber;\n', '        address player;\n', '        \n', '        \n', '    }\n', '    \n', '    mapping(uint256 =>  State) public Spudgame;\n', '    mapping(address => uint256) public playerVault;\n', '    mapping(address => uint256) public SpudCoin;\n', '    mapping(uint256 => address) public Rotator;\n', '    \n', '    uint256 public totalsupply;//spud totalsupply\n', '    uint256 public Pot; // pot that get&#39;s filled from entry mainly\n', '    uint256 public SpudPot; // divpot spucoins can be traded for\n', '    uint256 public round; //roundnumber\n', '    \n', '    uint256 public RNGdeterminator; // variable upon gameprogress\n', '    uint256 public nextspotnr; // next spot in rotator\n', '    \n', '    mapping(address => string) public Vanity;\n', '    \n', '    event Withdrawn(address indexed player, uint256 indexed amount);\n', '    event SpudRnG(address indexed player, uint256 indexed outcome);\n', '    event payout(address indexed player, uint256 indexed amount);\n', '    \n', '    function harvestabledivs()\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return ( p3dContract.myDividends(true))  ;\n', '    }\n', '    function contractownsthismanyP3D()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        \n', '        return (p3dContract.balanceOf(address(this)));\n', '    }\n', '    function getthismuchethforyourspud(uint256 amount)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 dividends = p3dContract.myDividends(true);\n', '            \n', '            uint256 amt = dividends.div(100);\n', '            \n', '            uint256 thepot = SpudPot.add(dividends.sub(amt));\n', '            \n', '        uint256 payouts = thepot.mul(amount).div(totalsupply);\n', '        return (payouts);\n', '    }\n', '    function thismanyblockstillthspudholderwins()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 value;\n', '        if(265-( block.number - Spudgame[round].blocknumber) >0){value = 265- (block.number - Spudgame[round].blocknumber);}\n', '        return (value);\n', '    }\n', '    function currentspudinfo()\n', '        public\n', '        view\n', '        returns(uint256, address)\n', '    {\n', '        \n', '        return (Spudgame[round].blocknumber, Spudgame[round].player);\n', '    }\n', '    function returntrueifcurrentplayerwinsround()\n', '        public\n', '        view\n', '        returns(bool)\n', '    {\n', '        uint256 refblocknr = Spudgame[round].blocknumber;\n', '        uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;\n', '        \n', '        bool result;\n', '        if(RNGresult == 1){result = true;}\n', '        if(refblocknr < block.number - 256){result = true;}\n', '        return (result);\n', '    }\n', '    //mods\n', '    modifier hasEarnings()\n', '    {\n', '        require(playerVault[msg.sender] > 0);\n', '        _;\n', '    }\n', '    \n', '    function() external payable {} // needed for P3D myDividends\n', '    //constructor\n', '    constructor()\n', '        public\n', '    {\n', '        Spudgame[0].player = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;\n', '        Spudgame[0].blocknumber = block.number;\n', '        RNGdeterminator = 6;\n', '        Rotator[0] = 0x989eB9629225B8C06997eF0577CC08535fD789F9;//raffle3d possible MN reward\n', '        nextspotnr++;\n', '    }\n', '    //vanity\n', '    \n', '    function changevanity(string van , address masternode) public payable\n', '    {\n', '        require(msg.value >= 1  finney);\n', '        Vanity[msg.sender] = van;\n', '        if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d&#39;s address\n', '        p3dContract.buy.value(msg.value)(masternode);\n', '    } \n', '    //\n', '     function withdraw()\n', '        external\n', '        hasEarnings\n', '    {\n', '       \n', '        \n', '        uint256 amount = playerVault[msg.sender];\n', '        playerVault[msg.sender] = 0;\n', '        \n', '        emit Withdrawn(msg.sender, amount); \n', '        \n', '        msg.sender.transfer(amount);\n', '    }\n', '    // main function\n', '    function GetSpud(address MN) public payable\n', '    {\n', '        require(msg.value >= 1  finney);\n', '        address sender = msg.sender;\n', '        uint256 blocknr = block.number;\n', '        uint256 curround = round;\n', '        uint256 refblocknr = Spudgame[curround].blocknumber;\n', '        \n', '        SpudCoin[MN]++;\n', '        totalsupply +=2;\n', '        SpudCoin[sender]++;\n', '        \n', '        // check previous RNG\n', '        \n', '        if(blocknr == refblocknr) \n', '        {\n', '            // just change state previous player does not win\n', '            \n', '            playerVault[msg.sender] += msg.value;\n', '            \n', '        }\n', '        if(blocknr - 256 <= refblocknr && blocknr != refblocknr)\n', '        {\n', '        \n', '        uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;\n', '        emit SpudRnG(Spudgame[curround].player , RNGresult) ;\n', '        \n', '        Pot += msg.value;\n', '        if(RNGresult == 1)\n', '        {\n', '            // won payout\n', '            uint256 RNGrotator = uint256(blockhash(refblocknr)) % nextspotnr;\n', '            address rotated = Rotator[RNGrotator]; \n', '            uint256 base = Pot.div(10);\n', '            p3dContract.buy.value(base)(rotated);\n', '            Spudgame[curround].player.transfer(base.mul(5));\n', '            emit payout(Spudgame[curround].player , base.mul(5));\n', '            Pot = Pot.sub(base.mul(6));\n', '            // ifpreviouswon => new round\n', '            uint256 nextround = curround+1;\n', '            Spudgame[nextround].player = sender;\n', '            Spudgame[nextround].blocknumber = blocknr;\n', '            \n', '            round++;\n', '            RNGdeterminator = 6;\n', '        }\n', '        if(RNGresult != 1)\n', '        {\n', '            // not won\n', '            \n', '            Spudgame[curround].player = sender;\n', '            Spudgame[curround].blocknumber = blocknr;\n', '        }\n', '        \n', '        \n', '        }\n', '        if(blocknr - 256 > refblocknr)\n', '        {\n', '            //win\n', '            // won payout\n', '            Pot += msg.value;\n', '            RNGrotator = uint256(blockhash(blocknr-1)) % nextspotnr;\n', '            rotated =Rotator[RNGrotator]; \n', '            base = Pot.div(10);\n', '            p3dContract.buy.value(base)(rotated);\n', '            Spudgame[round].player.transfer(base.mul(5));\n', '            emit payout(Spudgame[round].player , base.mul(5));\n', '            Pot = Pot.sub(base.mul(6));\n', '            // ifpreviouswon => new round\n', '            nextround = curround+1;\n', '            Spudgame[nextround].player = sender;\n', '            Spudgame[nextround].blocknumber = blocknr;\n', '            \n', '            round++;\n', '            RNGdeterminator = 6;\n', '        }\n', '        \n', '    } \n', '\n', 'function SpudToDivs(uint256 amount) public \n', '    {\n', '        address sender = msg.sender;\n', '        require(amount>0 && SpudCoin[sender] >= amount );\n', '         uint256 dividends = p3dContract.myDividends(true);\n', '            require(dividends > 0);\n', '            uint256 amt = dividends.div(100);\n', '            p3dContract.withdraw();\n', '            SPASM_.disburse.value(amt)();// to dev fee sharing contract SPASM\n', '            SpudPot = SpudPot.add(dividends.sub(amt));\n', '        uint256 payouts = SpudPot.mul(amount).div(totalsupply);\n', '        SpudPot = SpudPot.sub(payouts);\n', '        SpudCoin[sender] = SpudCoin[sender].sub(amount);\n', '        totalsupply = totalsupply.sub(amount);\n', '        sender.transfer(payouts);\n', '    } \n', 'function SpudToRotator(uint256 amount, address MN) public\n', '    {\n', '        address sender = msg.sender;\n', '        require(amount>0 && SpudCoin[sender] >= amount );\n', '        uint256 counter;\n', '    for(uint i=0; i< amount; i++)\n', '        {\n', '            counter = i + nextspotnr;\n', '            Rotator[counter] = MN;\n', '        }\n', '    nextspotnr += i;\n', '    SpudCoin[sender] = SpudCoin[sender].sub(amount);\n', '    totalsupply = totalsupply.sub(amount);\n', '    }\n', '}\n', '\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function withdraw() external;\n', '    function myDividends(bool _includeReferralBonus) external view returns(uint256);\n', '    function balanceOf(address _playerAddress) external view returns(uint256);\n', '}\n', 'interface SPASMInterface  {\n', '    function() payable external;\n', '    function disburse() external  payable;\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '// First Spielley and Dav collab on creating a Hot potato take for P3D\n', '// pass the spud, \n', '// each time you have the spud you can win the jackpot, \n', '// first player has most chance of hitting jackpot and slowly the chances of winning decrease. \n', "// if someone doesn't take over the spud within 256 blocks you auto win\n", '// each time you play you get a spudcoin\n', '// spudcoin reward for UI devs\n', '// spudcoins can be traded in for a part of the contracts divs\n', '// dependant on totalsupply and how many coins you trade in\n', '// you can also trade in spudcoin for spots in the MN rotator when the contract buys P3D\n', '// \n', '\n', 'contract Spud3D {\n', '    using SafeMath for uint;\n', '    \n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', "    SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//spielley's profit sharing payout\n", '    \n', '    struct State {\n', '        \n', '        uint256 blocknumber;\n', '        address player;\n', '        \n', '        \n', '    }\n', '    \n', '    mapping(uint256 =>  State) public Spudgame;\n', '    mapping(address => uint256) public playerVault;\n', '    mapping(address => uint256) public SpudCoin;\n', '    mapping(uint256 => address) public Rotator;\n', '    \n', '    uint256 public totalsupply;//spud totalsupply\n', "    uint256 public Pot; // pot that get's filled from entry mainly\n", '    uint256 public SpudPot; // divpot spucoins can be traded for\n', '    uint256 public round; //roundnumber\n', '    \n', '    uint256 public RNGdeterminator; // variable upon gameprogress\n', '    uint256 public nextspotnr; // next spot in rotator\n', '    \n', '    mapping(address => string) public Vanity;\n', '    \n', '    event Withdrawn(address indexed player, uint256 indexed amount);\n', '    event SpudRnG(address indexed player, uint256 indexed outcome);\n', '    event payout(address indexed player, uint256 indexed amount);\n', '    \n', '    function harvestabledivs()\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return ( p3dContract.myDividends(true))  ;\n', '    }\n', '    function contractownsthismanyP3D()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        \n', '        return (p3dContract.balanceOf(address(this)));\n', '    }\n', '    function getthismuchethforyourspud(uint256 amount)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 dividends = p3dContract.myDividends(true);\n', '            \n', '            uint256 amt = dividends.div(100);\n', '            \n', '            uint256 thepot = SpudPot.add(dividends.sub(amt));\n', '            \n', '        uint256 payouts = thepot.mul(amount).div(totalsupply);\n', '        return (payouts);\n', '    }\n', '    function thismanyblockstillthspudholderwins()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 value;\n', '        if(265-( block.number - Spudgame[round].blocknumber) >0){value = 265- (block.number - Spudgame[round].blocknumber);}\n', '        return (value);\n', '    }\n', '    function currentspudinfo()\n', '        public\n', '        view\n', '        returns(uint256, address)\n', '    {\n', '        \n', '        return (Spudgame[round].blocknumber, Spudgame[round].player);\n', '    }\n', '    function returntrueifcurrentplayerwinsround()\n', '        public\n', '        view\n', '        returns(bool)\n', '    {\n', '        uint256 refblocknr = Spudgame[round].blocknumber;\n', '        uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;\n', '        \n', '        bool result;\n', '        if(RNGresult == 1){result = true;}\n', '        if(refblocknr < block.number - 256){result = true;}\n', '        return (result);\n', '    }\n', '    //mods\n', '    modifier hasEarnings()\n', '    {\n', '        require(playerVault[msg.sender] > 0);\n', '        _;\n', '    }\n', '    \n', '    function() external payable {} // needed for P3D myDividends\n', '    //constructor\n', '    constructor()\n', '        public\n', '    {\n', '        Spudgame[0].player = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;\n', '        Spudgame[0].blocknumber = block.number;\n', '        RNGdeterminator = 6;\n', '        Rotator[0] = 0x989eB9629225B8C06997eF0577CC08535fD789F9;//raffle3d possible MN reward\n', '        nextspotnr++;\n', '    }\n', '    //vanity\n', '    \n', '    function changevanity(string van , address masternode) public payable\n', '    {\n', '        require(msg.value >= 1  finney);\n', '        Vanity[msg.sender] = van;\n', "        if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address\n", '        p3dContract.buy.value(msg.value)(masternode);\n', '    } \n', '    //\n', '     function withdraw()\n', '        external\n', '        hasEarnings\n', '    {\n', '       \n', '        \n', '        uint256 amount = playerVault[msg.sender];\n', '        playerVault[msg.sender] = 0;\n', '        \n', '        emit Withdrawn(msg.sender, amount); \n', '        \n', '        msg.sender.transfer(amount);\n', '    }\n', '    // main function\n', '    function GetSpud(address MN) public payable\n', '    {\n', '        require(msg.value >= 1  finney);\n', '        address sender = msg.sender;\n', '        uint256 blocknr = block.number;\n', '        uint256 curround = round;\n', '        uint256 refblocknr = Spudgame[curround].blocknumber;\n', '        \n', '        SpudCoin[MN]++;\n', '        totalsupply +=2;\n', '        SpudCoin[sender]++;\n', '        \n', '        // check previous RNG\n', '        \n', '        if(blocknr == refblocknr) \n', '        {\n', '            // just change state previous player does not win\n', '            \n', '            playerVault[msg.sender] += msg.value;\n', '            \n', '        }\n', '        if(blocknr - 256 <= refblocknr && blocknr != refblocknr)\n', '        {\n', '        \n', '        uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;\n', '        emit SpudRnG(Spudgame[curround].player , RNGresult) ;\n', '        \n', '        Pot += msg.value;\n', '        if(RNGresult == 1)\n', '        {\n', '            // won payout\n', '            uint256 RNGrotator = uint256(blockhash(refblocknr)) % nextspotnr;\n', '            address rotated = Rotator[RNGrotator]; \n', '            uint256 base = Pot.div(10);\n', '            p3dContract.buy.value(base)(rotated);\n', '            Spudgame[curround].player.transfer(base.mul(5));\n', '            emit payout(Spudgame[curround].player , base.mul(5));\n', '            Pot = Pot.sub(base.mul(6));\n', '            // ifpreviouswon => new round\n', '            uint256 nextround = curround+1;\n', '            Spudgame[nextround].player = sender;\n', '            Spudgame[nextround].blocknumber = blocknr;\n', '            \n', '            round++;\n', '            RNGdeterminator = 6;\n', '        }\n', '        if(RNGresult != 1)\n', '        {\n', '            // not won\n', '            \n', '            Spudgame[curround].player = sender;\n', '            Spudgame[curround].blocknumber = blocknr;\n', '        }\n', '        \n', '        \n', '        }\n', '        if(blocknr - 256 > refblocknr)\n', '        {\n', '            //win\n', '            // won payout\n', '            Pot += msg.value;\n', '            RNGrotator = uint256(blockhash(blocknr-1)) % nextspotnr;\n', '            rotated =Rotator[RNGrotator]; \n', '            base = Pot.div(10);\n', '            p3dContract.buy.value(base)(rotated);\n', '            Spudgame[round].player.transfer(base.mul(5));\n', '            emit payout(Spudgame[round].player , base.mul(5));\n', '            Pot = Pot.sub(base.mul(6));\n', '            // ifpreviouswon => new round\n', '            nextround = curround+1;\n', '            Spudgame[nextround].player = sender;\n', '            Spudgame[nextround].blocknumber = blocknr;\n', '            \n', '            round++;\n', '            RNGdeterminator = 6;\n', '        }\n', '        \n', '    } \n', '\n', 'function SpudToDivs(uint256 amount) public \n', '    {\n', '        address sender = msg.sender;\n', '        require(amount>0 && SpudCoin[sender] >= amount );\n', '         uint256 dividends = p3dContract.myDividends(true);\n', '            require(dividends > 0);\n', '            uint256 amt = dividends.div(100);\n', '            p3dContract.withdraw();\n', '            SPASM_.disburse.value(amt)();// to dev fee sharing contract SPASM\n', '            SpudPot = SpudPot.add(dividends.sub(amt));\n', '        uint256 payouts = SpudPot.mul(amount).div(totalsupply);\n', '        SpudPot = SpudPot.sub(payouts);\n', '        SpudCoin[sender] = SpudCoin[sender].sub(amount);\n', '        totalsupply = totalsupply.sub(amount);\n', '        sender.transfer(payouts);\n', '    } \n', 'function SpudToRotator(uint256 amount, address MN) public\n', '    {\n', '        address sender = msg.sender;\n', '        require(amount>0 && SpudCoin[sender] >= amount );\n', '        uint256 counter;\n', '    for(uint i=0; i< amount; i++)\n', '        {\n', '            counter = i + nextspotnr;\n', '            Rotator[counter] = MN;\n', '        }\n', '    nextspotnr += i;\n', '    SpudCoin[sender] = SpudCoin[sender].sub(amount);\n', '    totalsupply = totalsupply.sub(amount);\n', '    }\n', '}\n', '\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function withdraw() external;\n', '    function myDividends(bool _includeReferralBonus) external view returns(uint256);\n', '    function balanceOf(address _playerAddress) external view returns(uint256);\n', '}\n', 'interface SPASMInterface  {\n', '    function() payable external;\n', '    function disburse() external  payable;\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
