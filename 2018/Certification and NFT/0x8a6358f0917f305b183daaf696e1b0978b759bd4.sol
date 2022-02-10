['pragma solidity ^0.4.23;\n', '\n', '/*\n', '    Sale(address ethwallet)   // this will send the received ETH funds to this address\n', '  @author Yumerium Ltd\n', '*/\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function sale(address to, uint256 value) public;\n', '}\n', '\n', 'contract Sale {\n', '    uint public preSaleEnd = 1527120000; //05/24/2018 @ 12:00am (UTC)\n', '    uint public saleEnd1 = 1528588800; //06/10/2018 @ 12:00am (UTC)\n', '    uint public saleEnd2 = 1529971200; //06/26/2018 @ 12:00am (UTC)\n', '    uint public saleEnd3 = 1531267200; //07/11/2018 @ 12:00am (UTC)\n', '    uint public eventSaleEnd = 1537920000; // 09/26/2018 @ 12:00am (UTC)\n', '    uint public saleEnd4 = 1539129600; //10/10/2018 @ 12:00am (UTC)\n', '\n', '    uint256 public saleExchangeRate1 = 17500;\n', '    uint256 public saleExchangeRate2 = 10000;\n', '    uint256 public saleExchangeRate3 = 8750;\n', '    uint256 public saleExchangeRate4 = 7778;\n', '    uint256 public saleExchangeRate5 = 7368;\n', '    \n', '    uint256 public volumeType1 = 1429 * 10 ** 16; //14.29 eth\n', '    uint256 public volumeType2 = 7143 * 10 ** 16;\n', '    uint256 public volumeType3 = 14286 * 10 ** 16;\n', '    uint256 public volumeType4 = 42857 * 10 ** 16;\n', '    uint256 public volumeType5 = 71429 * 10 ** 16;\n', '    uint256 public volumeType6 = 142857 * 10 ** 16;\n', '    uint256 public volumeType7 = 428571 * 10 ** 16;\n', '    \n', '    uint256 public minEthValue = 10 ** 15; // 0.001 eth\n', '    \n', '    using SafeMath for uint256;\n', '    uint256 public maxSale;\n', '    uint256 public totalSaled;\n', '    ERC20 public Token;\n', '    address public ETHWallet;\n', '\n', '    address public creator;\n', '\n', '    mapping (address => uint256) public heldTokens;\n', '    mapping (address => uint) public heldTimeline;\n', '\n', '    event Contribution(address from, uint256 amount);\n', '\n', '    constructor(address _wallet, address _token_address) public {\n', '        maxSale = 316906850 * 10 ** 8; \n', '        ETHWallet = _wallet;\n', '        creator = msg.sender;\n', '        Token = ERC20(_token_address);\n', '    }\n', '\n', '    function () external payable {\n', '        buy();\n', '    }\n', '\n', '    // CONTRIBUTE FUNCTION\n', '    // converts ETH to TOKEN and sends new TOKEN to the sender\n', '    function contribute() external payable {\n', '        buy();\n', '    }\n', '    \n', '    \n', '    function buy() internal {\n', '        require(msg.value>=minEthValue);\n', '        require(now < saleEnd4); // main sale postponed\n', '        \n', '        uint256 amount;\n', '        uint256 exchangeRate;\n', '        if(now < preSaleEnd) {\n', '            exchangeRate = saleExchangeRate1;\n', '        } else if(now < saleEnd1) {\n', '            exchangeRate = saleExchangeRate2;\n', '        } else if(now < saleEnd2) {\n', '            exchangeRate = saleExchangeRate3;\n', '        } else if(now < eventSaleEnd) {\n', '            exchangeRate = saleExchangeRate4;\n', '        } else if(now < saleEnd4) {\n', '            exchangeRate = saleExchangeRate5;\n', '        }\n', '        \n', '        amount = msg.value.mul(exchangeRate).div(10 ** 10);\n', '        \n', '        if(msg.value >= volumeType7) {\n', '            amount = amount * 180 / 100;\n', '        } else if(msg.value >= volumeType6) {\n', '            amount = amount * 160 / 100;\n', '        } else if(msg.value >= volumeType5) {\n', '            amount = amount * 140 / 100;\n', '        } else if(msg.value >= volumeType4) {\n', '            amount = amount * 130 / 100;\n', '        } else if(msg.value >= volumeType3) {\n', '            amount = amount * 120 / 100;\n', '        } else if(msg.value >= volumeType2) {\n', '            amount = amount * 110 / 100;\n', '        } else if(msg.value >= volumeType1) {\n', '            amount = amount * 105 / 100;\n', '        }\n', '        \n', '        uint256 total = totalSaled + amount;\n', '        \n', '        require(total<=maxSale);\n', '        \n', '        totalSaled = total;\n', '        \n', '        ETHWallet.transfer(msg.value);\n', '        Token.sale(msg.sender, amount);\n', '        emit Contribution(msg.sender, amount);\n', '    }\n', '\n', '    // change creator address\n', '    function changeCreator(address _creator) external {\n', '        require(msg.sender==creator);\n', '        creator = _creator;\n', '    }\n', '\n', '}']