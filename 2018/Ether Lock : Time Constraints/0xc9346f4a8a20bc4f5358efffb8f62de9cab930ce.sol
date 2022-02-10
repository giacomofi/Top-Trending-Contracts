['pragma solidity ^0.4.21;\n', '\n', '// Written by EtherGuy\n', '// UI: GasWar.surge.sh \n', '// Mail: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="2a4f5e424f584d5f536a474b434604494547">[email&#160;protected]</a>\n', '\n', 'contract GasWar{\n', '    \n', '    \n', '    // OPEN 20:00 -> 22:00 UTC \n', '  //  uint256 public UTCStart = (20 hours); \n', '//    uint256 public UTCStop = (22 hours);\n', '    \n', '    // dev \n', '    uint256 public UTCStart = (2 hours);\n', '    uint256 public UTCStop = (4 hours);\n', '    \n', '    uint256 public RoundTime = (5 minutes);\n', '    uint256 public Price = (0.005 ether);\n', '    \n', '    uint256 public RoundEndTime;\n', '    \n', '    \n', '    uint256 public GasPrice = 0;\n', '    address public Winner;\n', '    //uint256 public  Pot;\n', '    \n', '    uint256 public TakePot = 8000; // 80% \n', '    \n', '\n', '    \n', '    event GameStart(uint256 EndTime);\n', '    event GameWon(address Winner, uint256 Take);\n', '    event NewGameLeader(address Leader, uint256 GasPrice, uint256 pot);\n', '    event NewTX(uint256 pot);\n', '    \n', '    address owner;\n', '\n', '    function GasWar() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function Open() public view returns (bool){\n', '        uint256 sliced = now % (1 days);\n', '        return (sliced >= UTCStart && sliced <= UTCStop);\n', '    }\n', '    \n', '    function NextOpen() public view returns (uint256, uint256){\n', '        \n', '        uint256 sliced = now % (1 days);\n', '        if (sliced > UTCStop){\n', '            uint256 ret2 = (UTCStop) - sliced + UTCStop;\n', '            return (ret2, now + ret2);\n', '        }\n', '        else{\n', '            uint256 ret1 = (UTCStart - sliced);\n', '            return (ret1, now + ret1);\n', '        }\n', '    }\n', '    \n', '    \n', '\n', '\n', '    \n', '    function Withdraw() public {\n', '       \n', '        //_withdraw(false);\n', '        // check game withdraws from now on, false prevent re-entrancy\n', '        CheckGameStart(false);\n', '    }\n', '    \n', '    // please no re-entrancy\n', '    function _withdraw(bool reduce_price) internal {\n', '        // One call. \n', '         require((now > RoundEndTime));\n', '        require (Winner != 0x0);\n', '        \n', '        uint256 subber = 0;\n', '        if (reduce_price){\n', '            subber = Price;\n', '        }\n', '        uint256 Take = (mul(sub(address(this).balance,subber), TakePot)) / 10000;\n', '        Winner.transfer(Take);\n', '\n', '        \n', '        emit GameWon(Winner, Take);\n', '        \n', '        Winner = 0x0;\n', '        GasPrice = 0;\n', '    }\n', '    \n', '    function CheckGameStart(bool remove_price) internal returns (bool){\n', '        if (Winner != 0x0){\n', '            // if game open remove price from balance \n', '            // this is to make sure winner does not get extra eth from new round.\n', '            _withdraw(remove_price && Open()); // sorry mate, much gas.\n', '\n', '        }\n', '        if (Winner == 0x0 && Open()){\n', '            Winner = msg.sender; // from withdraw the gas max is 0.\n', '            RoundEndTime = now + RoundTime;\n', '            emit GameStart(RoundEndTime);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    // Function to start game without spending gas. \n', '    //function PublicCheckGameStart() public {\n', '    //    require(now > RoundEndTime);\n', '    //    CheckGameStart();\n', '    //}\n', '    // reverted; allows contract drain @ inactive, this should not be the case.\n', '        \n', '    function BuyIn() public payable {\n', '        // We are not going to do any retarded shit here \n', '        // If you send too much or too less ETH you get rejected \n', '        // Gas Price is OK but burning lots of it is BS \n', '        // Sending a TX is 21k gas\n', '        // If you are going to win you already gotta pay 20k gas to set setting \n', '        require(msg.value == Price);\n', '        \n', '        \n', '        if (now > RoundEndTime){\n', '            bool started = CheckGameStart(true);\n', '            require(started);\n', '            GasPrice = tx.gasprice;\n', '            emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);\n', '        }\n', '        else{\n', '            if (tx.gasprice > GasPrice){\n', '                GasPrice = tx.gasprice;\n', '                Winner = msg.sender;\n', '                emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);\n', '            }\n', '        }\n', '        \n', '        // not reverted \n', '        \n', '        owner.transfer((msg.value * 500)/10000); // 5%\n', '        \n', '        emit NewTX(address(this).balance + (Price * 95)/100);\n', '    }\n', '    \n', '    // Dev functions to change settings after this line \n', ' \n', '     // dev close game \n', '     // instructions \n', '     // send v=10000 to this one \n', '    function SetTakePot(uint256 v) public {\n', '        require(msg.sender==owner);\n', '        require (v <= 10000);\n', '        require(v >= 1000); // do not set v <10% prevent contract blackhole; \n', '        TakePot = v;\n', '    }\n', '    \n', '    function SetTimes(uint256 NS, uint256 NE) public {\n', '        require(msg.sender==owner);\n', '        require(NS < (1 days));\n', '        require(NE < (1 days));\n', '        UTCStart = NS;\n', '        UTCStop = NE;\n', '    }\n', '    \n', '    function SetPrice(uint256 p) public {\n', '        require(msg.sender == owner);\n', '        require(!Open() && (Winner == 0x0)); // dont change game price while running you retard\n', '        Price = p;\n', '    }    \n', '    \n', '    function SetRoundTime(uint256 p) public{\n', '        require(msg.sender == owner);\n', '        require(!Open() && (Winner == 0x0));\n', '        RoundTime = p;\n', '    }   \n', ' \n', ' \n', ' \n', ' \tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', '\t\t// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', ' \n', ' \n', '    \n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// Written by EtherGuy\n', '// UI: GasWar.surge.sh \n', '// Mail: etherguy@mail.com\n', '\n', 'contract GasWar{\n', '    \n', '    \n', '    // OPEN 20:00 -> 22:00 UTC \n', '  //  uint256 public UTCStart = (20 hours); \n', '//    uint256 public UTCStop = (22 hours);\n', '    \n', '    // dev \n', '    uint256 public UTCStart = (2 hours);\n', '    uint256 public UTCStop = (4 hours);\n', '    \n', '    uint256 public RoundTime = (5 minutes);\n', '    uint256 public Price = (0.005 ether);\n', '    \n', '    uint256 public RoundEndTime;\n', '    \n', '    \n', '    uint256 public GasPrice = 0;\n', '    address public Winner;\n', '    //uint256 public  Pot;\n', '    \n', '    uint256 public TakePot = 8000; // 80% \n', '    \n', '\n', '    \n', '    event GameStart(uint256 EndTime);\n', '    event GameWon(address Winner, uint256 Take);\n', '    event NewGameLeader(address Leader, uint256 GasPrice, uint256 pot);\n', '    event NewTX(uint256 pot);\n', '    \n', '    address owner;\n', '\n', '    function GasWar() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function Open() public view returns (bool){\n', '        uint256 sliced = now % (1 days);\n', '        return (sliced >= UTCStart && sliced <= UTCStop);\n', '    }\n', '    \n', '    function NextOpen() public view returns (uint256, uint256){\n', '        \n', '        uint256 sliced = now % (1 days);\n', '        if (sliced > UTCStop){\n', '            uint256 ret2 = (UTCStop) - sliced + UTCStop;\n', '            return (ret2, now + ret2);\n', '        }\n', '        else{\n', '            uint256 ret1 = (UTCStart - sliced);\n', '            return (ret1, now + ret1);\n', '        }\n', '    }\n', '    \n', '    \n', '\n', '\n', '    \n', '    function Withdraw() public {\n', '       \n', '        //_withdraw(false);\n', '        // check game withdraws from now on, false prevent re-entrancy\n', '        CheckGameStart(false);\n', '    }\n', '    \n', '    // please no re-entrancy\n', '    function _withdraw(bool reduce_price) internal {\n', '        // One call. \n', '         require((now > RoundEndTime));\n', '        require (Winner != 0x0);\n', '        \n', '        uint256 subber = 0;\n', '        if (reduce_price){\n', '            subber = Price;\n', '        }\n', '        uint256 Take = (mul(sub(address(this).balance,subber), TakePot)) / 10000;\n', '        Winner.transfer(Take);\n', '\n', '        \n', '        emit GameWon(Winner, Take);\n', '        \n', '        Winner = 0x0;\n', '        GasPrice = 0;\n', '    }\n', '    \n', '    function CheckGameStart(bool remove_price) internal returns (bool){\n', '        if (Winner != 0x0){\n', '            // if game open remove price from balance \n', '            // this is to make sure winner does not get extra eth from new round.\n', '            _withdraw(remove_price && Open()); // sorry mate, much gas.\n', '\n', '        }\n', '        if (Winner == 0x0 && Open()){\n', '            Winner = msg.sender; // from withdraw the gas max is 0.\n', '            RoundEndTime = now + RoundTime;\n', '            emit GameStart(RoundEndTime);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    // Function to start game without spending gas. \n', '    //function PublicCheckGameStart() public {\n', '    //    require(now > RoundEndTime);\n', '    //    CheckGameStart();\n', '    //}\n', '    // reverted; allows contract drain @ inactive, this should not be the case.\n', '        \n', '    function BuyIn() public payable {\n', '        // We are not going to do any retarded shit here \n', '        // If you send too much or too less ETH you get rejected \n', '        // Gas Price is OK but burning lots of it is BS \n', '        // Sending a TX is 21k gas\n', '        // If you are going to win you already gotta pay 20k gas to set setting \n', '        require(msg.value == Price);\n', '        \n', '        \n', '        if (now > RoundEndTime){\n', '            bool started = CheckGameStart(true);\n', '            require(started);\n', '            GasPrice = tx.gasprice;\n', '            emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);\n', '        }\n', '        else{\n', '            if (tx.gasprice > GasPrice){\n', '                GasPrice = tx.gasprice;\n', '                Winner = msg.sender;\n', '                emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);\n', '            }\n', '        }\n', '        \n', '        // not reverted \n', '        \n', '        owner.transfer((msg.value * 500)/10000); // 5%\n', '        \n', '        emit NewTX(address(this).balance + (Price * 95)/100);\n', '    }\n', '    \n', '    // Dev functions to change settings after this line \n', ' \n', '     // dev close game \n', '     // instructions \n', '     // send v=10000 to this one \n', '    function SetTakePot(uint256 v) public {\n', '        require(msg.sender==owner);\n', '        require (v <= 10000);\n', '        require(v >= 1000); // do not set v <10% prevent contract blackhole; \n', '        TakePot = v;\n', '    }\n', '    \n', '    function SetTimes(uint256 NS, uint256 NE) public {\n', '        require(msg.sender==owner);\n', '        require(NS < (1 days));\n', '        require(NE < (1 days));\n', '        UTCStart = NS;\n', '        UTCStop = NE;\n', '    }\n', '    \n', '    function SetPrice(uint256 p) public {\n', '        require(msg.sender == owner);\n', '        require(!Open() && (Winner == 0x0)); // dont change game price while running you retard\n', '        Price = p;\n', '    }    \n', '    \n', '    function SetRoundTime(uint256 p) public{\n', '        require(msg.sender == owner);\n', '        require(!Open() && (Winner == 0x0));\n', '        RoundTime = p;\n', '    }   \n', ' \n', ' \n', ' \n', ' \tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', ' \n', ' \n', '    \n', '}']
