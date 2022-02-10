['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', '  * @title SafeMath\n', '  * @dev Math operations with safety checks that throw on error\n', '  */\n', 'library SafeMath {\n', '/**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to relinquish control of the contract.\n', '    */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract VANMToken is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    //Variables\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint256 public _totalSupply;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    uint256 public presaleSupply;\n', '    address public presaleAddress;\n', '\n', '    uint256 public crowdsaleSupply;\n', '    address public crowdsaleAddress;\n', '\n', '    uint256 public platformSupply;\n', '    address public platformAddress;\n', '\n', '    uint256 public incentivisingSupply;\n', '    address public incentivisingAddress;\n', '\n', '    uint256 public teamSupply;\n', '    address public teamAddress;\n', '\n', '    uint256 public crowdsaleEndsAt;\n', '\n', '    uint256 public teamVestingPeriod;\n', '\n', '    bool public presaleFinalized = false;\n', '\n', '    bool public crowdsaleFinalized = false;\n', '\n', '    //Modifiers\n', '    //Only presale contract\n', '    modifier onlyPresale() {\n', '        require(msg.sender == presaleAddress);\n', '        _;\n', '    }\n', '\n', '    //Only crowdsale contract\n', '    modifier onlyCrowdsale() {\n', '        require(msg.sender == crowdsaleAddress);\n', '        _;\n', '    }\n', '\n', '    //crowdsale has to be over\n', '    modifier notBeforeCrowdsaleEnds(){\n', '        require(block.timestamp >= crowdsaleEndsAt);\n', '        _;\n', '    }\n', '\n', '    // Check if vesting period is over\n', '    modifier checkTeamVestingPeriod() {\n', '        require(block.timestamp >= teamVestingPeriod);\n', '        _;\n', '    }\n', '\n', '    //Events\n', '    event PresaleFinalized(uint tokensRemaining);\n', '\n', '    event CrowdsaleFinalized(uint tokensRemaining);\n', '\n', '    //Constructor\n', '    constructor() public {\n', '\n', '        //Basic information\n', '        symbol = "VANM";\n', '        name = "VANM";\n', '        decimals = 18;\n', '\n', '        //Total VANM supply\n', '        _totalSupply = 240000000 * 10**uint256(decimals);\n', '\n', '        // 10% of total supply for presale\n', '        presaleSupply = 24000000 * 10**uint256(decimals);\n', '\n', '        // 50% of total supply for crowdsale\n', '        crowdsaleSupply = 120000000 * 10**uint256(decimals);\n', '\n', '        // 10% of total supply for platform\n', '        platformSupply = 24000000 * 10**uint256(decimals);\n', '\n', '        // 20% of total supply for incentivising\n', '        incentivisingSupply = 48000000 * 10**uint256(decimals);\n', '\n', '        // 10% of total supply for team\n', '        teamSupply = 24000000 * 10**uint256(decimals);\n', '\n', '        platformAddress = 0x6962371D5a9A229C735D936df5CE6C690e66b718;\n', '\n', '        teamAddress = 0xB9e54846da59C27eFFf06C3C08D5d108CF81FEae;\n', '\n', '        // 01.05.2019 00:00:00 UTC\n', '        crowdsaleEndsAt = 1556668800;\n', '\n', '        // 2 years vesting period\n', '        teamVestingPeriod = crowdsaleEndsAt.add(2 * 365 * 1 days);\n', '\n', '        balances[platformAddress] = platformSupply;\n', '        emit Transfer(0x0, platformAddress, platformSupply);\n', '\n', '        balances[incentivisingAddress] = incentivisingSupply;\n', '    }\n', '\n', '    //External functions\n', "    //Set Presale Address when it's deployed\n", '    function setPresaleAddress(address _presaleAddress) external onlyOwner {\n', '        require(presaleAddress == 0x0);\n', '        presaleAddress = _presaleAddress;\n', '        balances[_presaleAddress] = balances[_presaleAddress].add(presaleSupply);\n', '    }\n', '\n', '    // Finalize presale. Leftover tokens will overflow to crowdsale.\n', '    function finalizePresale() external onlyPresale {\n', '        require(presaleFinalized == false);\n', '        uint256 amount = balanceOf(presaleAddress);\n', '        if (amount > 0) {\n', '            balances[presaleAddress] = 0;\n', '            balances[crowdsaleAddress] = balances[crowdsaleAddress].add(amount);\n', '        }\n', '        presaleFinalized = true;\n', '        emit PresaleFinalized(amount);\n', '    }\n', '\n', "    //Set Crowdsale Address when it's deployed\n", '    function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {\n', '        require(presaleAddress != 0x0);\n', '        require(crowdsaleAddress == 0x0);\n', '        crowdsaleAddress = _crowdsaleAddress;\n', '        balances[_crowdsaleAddress] = balances[_crowdsaleAddress].add(crowdsaleSupply);\n', '    }\n', '\n', '    // Finalize crowdsale. Leftover tokens will overflow to platform.\n', '    function finalizeCrowdsale() external onlyCrowdsale {\n', '        require(presaleFinalized == true && crowdsaleFinalized == false);\n', '        uint256 amount = balanceOf(crowdsaleAddress);\n', '        if (amount > 0) {\n', '            balances[crowdsaleAddress] = 0;\n', '            balances[platformAddress] = balances[platformAddress].add(amount);\n', '            emit Transfer(0x0, platformAddress, amount);\n', '        }\n', '        crowdsaleFinalized = true;\n', '        emit CrowdsaleFinalized(amount);\n', '    }\n', '\n', '    //Public functions\n', '    //ERC20 functions\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public\n', '    notBeforeCrowdsaleEnds\n', '    returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public\n', '    notBeforeCrowdsaleEnds\n', '    returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    //Token functions\n', '    //Incentivising function to transfer tokens\n', '    function transferFromIncentivising(address _to, uint256 _value) public\n', '    onlyOwner\n', '    returns (bool) {\n', '    require(_value <= balances[incentivisingAddress]);\n', '        balances[incentivisingAddress] = balances[incentivisingAddress].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(0x0, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //Presalefunction to transfer tokens\n', '    function transferFromPresale(address _to, uint256 _value) public\n', '    onlyPresale\n', '    returns (bool) {\n', '    require(_value <= balances[presaleAddress]);\n', '        balances[presaleAddress] = balances[presaleAddress].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(0x0, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //Crowdsalefunction to transfer tokens\n', '    function transferFromCrowdsale(address _to, uint256 _value) public\n', '    onlyCrowdsale\n', '    returns (bool) {\n', '    require(_value <= balances[crowdsaleAddress]);\n', '        balances[crowdsaleAddress] = balances[crowdsaleAddress].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(0x0, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // Release team supply after vesting period is finished.\n', '    function releaseTeamTokens() public checkTeamVestingPeriod onlyOwner returns(bool) {\n', '        require(teamSupply > 0);\n', '        balances[teamAddress] = teamSupply;\n', '        emit Transfer(0x0, teamAddress, teamSupply);\n', '        teamSupply = 0;\n', '        return true;\n', '    }\n', '\n', '    //Check remaining incentivising tokens\n', '    function checkIncentivisingBalance() public view returns (uint256) {\n', '        return balances[incentivisingAddress];\n', '    }\n', '\n', '    //Check remaining presale tokens after presale contract is deployed\n', '    function checkPresaleBalance() public view returns (uint256) {\n', '        return balances[presaleAddress];\n', '    }\n', '\n', '    //Check remaining crowdsale tokens after crowdsale contract is deployed\n', '    function checkCrowdsaleBalance() public view returns (uint256) {\n', '        return balances[crowdsaleAddress];\n', '    }\n', '\n', '    //Recover ERC20 Tokens\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', "    //Don't accept ETH\n", '    function () public payable {\n', 'revert();\n', '    }\n', '}']