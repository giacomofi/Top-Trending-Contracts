['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title IHFVesting\n', ' * @dev IHFVesting is a token holder contract that allows the specified beneficiary\n', ' * to claim stored tokens after 6 month intervals\n', '*/\n', '\n', ' contract IHFVesting {\n', '    using SafeMath for uint256;\n', '\n', '    address public beneficiary;\n', '    uint256 public fundingEndBlock;\n', '\n', '    bool private initClaim = false; // state tracking variables\n', '\n', '    uint256 public firstRelease; // vesting times\n', '    bool private firstDone = false;\n', '    uint256 public secondRelease;\n', '    bool private secondDone = false;\n', '    uint256 public thirdRelease;\n', '    bool private thirdDone = false;\n', '    uint256 public fourthRelease;\n', '\n', '    ERC20Basic public ERC20Token; // ERC20 basic token contract to hold\n', '\n', '    enum Stages {\n', '        initClaim,\n', '        firstRelease,\n', '        secondRelease,\n', '        thirdRelease,\n', '        fourthRelease\n', '    }\n', '\n', '    Stages public stage = Stages.initClaim;\n', '\n', '    modifier atStage(Stages _stage) {\n', '        if(stage == _stage) _;\n', '    }\n', '\n', '    function IHFVesting(address _token, uint256 fundingEndBlockInput) public {\n', '        require(_token != address(0));\n', '        beneficiary = msg.sender;\n', '        fundingEndBlock = fundingEndBlockInput;\n', '        ERC20Token = ERC20Basic(_token);\n', '    }\n', '\n', '    function changeBeneficiary(address newBeneficiary) external {\n', '        require(newBeneficiary != address(0));\n', '        require(msg.sender == beneficiary);\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    function updateFundingEndBlock(uint256 newFundingEndBlock) public {\n', '        require(msg.sender == beneficiary);\n', '        require(block.number < fundingEndBlock);\n', '        require(block.number < newFundingEndBlock);\n', '        fundingEndBlock = newFundingEndBlock;\n', '    }\n', '\n', '    function checkBalance() public view returns (uint256 tokenBalance) {\n', '        return ERC20Token.balanceOf(this);\n', '    }\n', '\n', '    // in total 2.5% of IHF tokens will be sent to this contract\n', '    // INVICTUS: 1%\n', '    // TEAM: 1.5%\n', '    //  initalPaymen: 0.3%\n', '    //  firstRelease: 0.3%\n', '    //  secondRelease: 0.3%\n', '    //  thirdRelease: 0.3%\n', '    //  fourthRelease: 0.3%\n', '    // initial claim is Invictus + initial team payment\n', '    // initial claim is thus (1 + 0.3)/2.5 = 52% of C20 tokens sent here\n', '    // each other release (for team) is 12% of tokens sent here\n', '\n', '    function claim() external {\n', '        require(msg.sender == beneficiary);\n', '        require(block.number > fundingEndBlock);\n', '        uint256 balance = ERC20Token.balanceOf(this);\n', '        // in reverse order so stages changes don&#39;t carry within one claim\n', '        fourth_release(balance);\n', '        third_release(balance);\n', '        second_release(balance);\n', '        first_release(balance);\n', '        init_claim(balance);\n', '    }\n', '\n', '    function nextStage() private {\n', '        stage = Stages(uint256(stage) + 1);\n', '    }\n', '\n', '    function init_claim(uint256 balance) private atStage(Stages.initClaim) {\n', '        firstRelease = now + 26 weeks; // assign 4 claiming times\n', '        secondRelease = firstRelease + 26 weeks;\n', '        thirdRelease = secondRelease + 26 weeks;\n', '        fourthRelease = thirdRelease + 26 weeks;\n', '        uint256 amountToTransfer = balance.mul(52).div(100);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // now 48% tokens left\n', '        nextStage();\n', '    }\n', '    function first_release(uint256 balance) private atStage(Stages.firstRelease) {\n', '        require(now > firstRelease);\n', '        uint256 amountToTransfer = balance.div(4);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function second_release(uint256 balance) private atStage(Stages.secondRelease) {\n', '        require(now > secondRelease);\n', '        uint256 amountToTransfer = balance.div(3);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function third_release(uint256 balance) private atStage(Stages.thirdRelease) {\n', '        require(now > thirdRelease);\n', '        uint256 amountToTransfer = balance.div(2);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function fourth_release(uint256 balance) private atStage(Stages.fourthRelease) {\n', '        require(now > fourthRelease);\n', '        ERC20Token.transfer(beneficiary, balance); // send remaining 25 % of team releases\n', '    }\n', '\n', '    function claimOtherTokens(address _token) external {\n', '        require(msg.sender == beneficiary);\n', '        require(_token != address(0));\n', '        ERC20Basic token = ERC20Basic(_token);\n', '        require(token != ERC20Token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(beneficiary, balance);\n', '     }\n', '\n', ' }']
['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title IHFVesting\n', ' * @dev IHFVesting is a token holder contract that allows the specified beneficiary\n', ' * to claim stored tokens after 6 month intervals\n', '*/\n', '\n', ' contract IHFVesting {\n', '    using SafeMath for uint256;\n', '\n', '    address public beneficiary;\n', '    uint256 public fundingEndBlock;\n', '\n', '    bool private initClaim = false; // state tracking variables\n', '\n', '    uint256 public firstRelease; // vesting times\n', '    bool private firstDone = false;\n', '    uint256 public secondRelease;\n', '    bool private secondDone = false;\n', '    uint256 public thirdRelease;\n', '    bool private thirdDone = false;\n', '    uint256 public fourthRelease;\n', '\n', '    ERC20Basic public ERC20Token; // ERC20 basic token contract to hold\n', '\n', '    enum Stages {\n', '        initClaim,\n', '        firstRelease,\n', '        secondRelease,\n', '        thirdRelease,\n', '        fourthRelease\n', '    }\n', '\n', '    Stages public stage = Stages.initClaim;\n', '\n', '    modifier atStage(Stages _stage) {\n', '        if(stage == _stage) _;\n', '    }\n', '\n', '    function IHFVesting(address _token, uint256 fundingEndBlockInput) public {\n', '        require(_token != address(0));\n', '        beneficiary = msg.sender;\n', '        fundingEndBlock = fundingEndBlockInput;\n', '        ERC20Token = ERC20Basic(_token);\n', '    }\n', '\n', '    function changeBeneficiary(address newBeneficiary) external {\n', '        require(newBeneficiary != address(0));\n', '        require(msg.sender == beneficiary);\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    function updateFundingEndBlock(uint256 newFundingEndBlock) public {\n', '        require(msg.sender == beneficiary);\n', '        require(block.number < fundingEndBlock);\n', '        require(block.number < newFundingEndBlock);\n', '        fundingEndBlock = newFundingEndBlock;\n', '    }\n', '\n', '    function checkBalance() public view returns (uint256 tokenBalance) {\n', '        return ERC20Token.balanceOf(this);\n', '    }\n', '\n', '    // in total 2.5% of IHF tokens will be sent to this contract\n', '    // INVICTUS: 1%\n', '    // TEAM: 1.5%\n', '    //  initalPaymen: 0.3%\n', '    //  firstRelease: 0.3%\n', '    //  secondRelease: 0.3%\n', '    //  thirdRelease: 0.3%\n', '    //  fourthRelease: 0.3%\n', '    // initial claim is Invictus + initial team payment\n', '    // initial claim is thus (1 + 0.3)/2.5 = 52% of C20 tokens sent here\n', '    // each other release (for team) is 12% of tokens sent here\n', '\n', '    function claim() external {\n', '        require(msg.sender == beneficiary);\n', '        require(block.number > fundingEndBlock);\n', '        uint256 balance = ERC20Token.balanceOf(this);\n', "        // in reverse order so stages changes don't carry within one claim\n", '        fourth_release(balance);\n', '        third_release(balance);\n', '        second_release(balance);\n', '        first_release(balance);\n', '        init_claim(balance);\n', '    }\n', '\n', '    function nextStage() private {\n', '        stage = Stages(uint256(stage) + 1);\n', '    }\n', '\n', '    function init_claim(uint256 balance) private atStage(Stages.initClaim) {\n', '        firstRelease = now + 26 weeks; // assign 4 claiming times\n', '        secondRelease = firstRelease + 26 weeks;\n', '        thirdRelease = secondRelease + 26 weeks;\n', '        fourthRelease = thirdRelease + 26 weeks;\n', '        uint256 amountToTransfer = balance.mul(52).div(100);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // now 48% tokens left\n', '        nextStage();\n', '    }\n', '    function first_release(uint256 balance) private atStage(Stages.firstRelease) {\n', '        require(now > firstRelease);\n', '        uint256 amountToTransfer = balance.div(4);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function second_release(uint256 balance) private atStage(Stages.secondRelease) {\n', '        require(now > secondRelease);\n', '        uint256 amountToTransfer = balance.div(3);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function third_release(uint256 balance) private atStage(Stages.thirdRelease) {\n', '        require(now > thirdRelease);\n', '        uint256 amountToTransfer = balance.div(2);\n', '        ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases\n', '        nextStage();\n', '    }\n', '    function fourth_release(uint256 balance) private atStage(Stages.fourthRelease) {\n', '        require(now > fourthRelease);\n', '        ERC20Token.transfer(beneficiary, balance); // send remaining 25 % of team releases\n', '    }\n', '\n', '    function claimOtherTokens(address _token) external {\n', '        require(msg.sender == beneficiary);\n', '        require(_token != address(0));\n', '        ERC20Basic token = ERC20Basic(_token);\n', '        require(token != ERC20Token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(beneficiary, balance);\n', '     }\n', '\n', ' }']
