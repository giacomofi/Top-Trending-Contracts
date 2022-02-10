['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(owner==msg.sender);\n', '    _;\n', ' }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      owner = newOwner;\n', '  }\n', '}\n', '  \n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BetleyToken is Ownable, ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Token properties\n', '    string public name = "BetleyToken";               //Token name\n', '    string public symbol = "BETS";                     //Token symbol\n', '    uint256 public decimals = 18;\n', '\n', '    uint256 public _totalSupply = 1000000000e18;       //100% Total Supply\n', '\t\n', '    uint256 public _mainsaleSupply = 350000000e18;     //35% Main Sale\n', '    uint256 public _presaleSupply = 650000000e18;      //65% Pre Sale\n', '\t\n', '    uint256 public _saleSupply = 390000000e18;         //60% Sale\n', '    uint256 public _teamSupply = 65000000e18;          //10% Team\n', '    uint256 public _advisorsSupply = 55250000e18;      //8.5% Advisors\n', '    uint256 public _platformSupply = 130000000e18;     //20% Platform\n', '    uint256 public _bountySupply = 9750000e18;         //1.5% Bounty\n', '\n', '    // Address of owners who will get distribution tokens\n', '    address private _teamAddress = 0x5cFDe81cF1ACa91Ff8b7fEa63cFBF81B713BBf00;\n', '    address private _advisorsAddress = 0xC9F2DE0826235767c95254E1887e607d9Af7aA81;\n', '    address private _platformAddress = 0x572eE1910DD287FCbB109320098B7EcC33CB7e51;\n', '    address private _bountyAddress = 0xb496FB1F0660CccA92D1B4B199eDcC4Eb8992bfA;\n', '    uint256 public isDistributionTransferred = 0;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '    \n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public preSaleStartTime; \n', '    uint256 public mainSaleStartTime;\n', '\n', '    // Wallet Address of Token\n', '    address public multisig;\n', '\n', '    // Wallet Adddress of Secured User\n', '    address public sec_addr;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public price;\n', '\n', '    uint256 public minContribAmount = 0.1 ether;\n', '    uint256 public maxContribAmount = 100 ether;\n', '\n', '    uint256 public hardCap = 30000 ether;\n', '    uint256 public softCap = 1200 ether;\n', '    \n', '    //number of total tokens sold \n', '    uint256 public presaleTotalNumberTokenSold=0;\n', '    uint256 public mainsaleTotalNumberTokenSold=0;\n', '\n', '    bool public tradable = false;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    modifier canTradable() {\n', '        require(tradable || ((now < mainSaleStartTime + 30 days) && (now > preSaleStartTime)));\n', '        _;\n', '    }\n', '\n', '    // Constructor\n', '    // @notice BetleyToken Contract\n', '    // @return the transaction address\n', '    function BetleyToken() public{\n', '        // Initial Owner Wallet Address\n', '        multisig = 0x7BAD2a7C2c2E83f0a6E9Afbd3cC0029391F3B013;\n', '\n', '        balances[multisig] = _totalSupply;\n', '\n', '        preSaleStartTime = 1527811200; // June 1st 10:00 AEST\n', '        mainSaleStartTime = 1533081600; // August 1st 10:00 AEST\n', '\n', '        owner = msg.sender;\n', '\n', '        sendTeamSupplyToken(_teamAddress);\n', '        sendAdvisorsSupplyToken(_advisorsAddress);\n', '        sendPlatformSupplyToken(_platformAddress);\n', '        sendBountySupplyToken(_bountyAddress);\n', '        isDistributionTransferred = 1;\n', '    }\n', '\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () external payable {\n', '        tokensale(msg.sender);\n', '    }\n', '\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        require(recipient != 0x0);\n', '        require(msg.value >= minContribAmount && msg.value <= maxContribAmount);\n', '        price = getPrice();\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokenToSend = weiAmount.mul(price);\n', '        \n', '        require(tokenToSend > 0);\n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {\n', '\t\t\n', '\t\t\trequire(_presaleSupply >= tokenToSend);\n', '\t\t\n', '        } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '            \t\n', '            require(_mainsaleSupply >= tokenToSend);\n', '        \n', '\t\t}\n', '        \n', '        balances[multisig] = balances[multisig].sub(tokenToSend);\n', '        balances[recipient] = balances[recipient].add(tokenToSend);\n', '        \n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {\n', '            \n', '\t\t\tpresaleTotalNumberTokenSold = presaleTotalNumberTokenSold.add(tokenToSend);\n', '            _presaleSupply = _presaleSupply.sub(tokenToSend);\n', '        \n', '\t\t} else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '            \n', '\t\t\tmainsaleTotalNumberTokenSold = mainsaleTotalNumberTokenSold.add(tokenToSend);\n', '            _mainsaleSupply = _mainsaleSupply.sub(tokenToSend);\n', '        \n', '\t\t}\n', '\n', '        address tar_addr = multisig;\n', '        if (presaleTotalNumberTokenSold + mainsaleTotalNumberTokenSold > 10000000) { // Transfers ETHER to wallet after softcap is hit\n', '            tar_addr = sec_addr;\n', '        }\n', '        tar_addr.transfer(msg.value);\n', '        TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);\n', '    }\n', '\n', '    // Security Wallet address setting\n', '    function setSecurityWalletAddr(address addr) public onlyOwner {\n', '        sec_addr = addr;\n', '    }\n', '\n', '    // Token distribution to Team\n', '    function sendTeamSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_teamSupply);\n', '        balances[to] = balances[to].add(_teamSupply);\n', '        Transfer(multisig, to, _teamSupply);\n', '    }\n', '\n', '    // Token distribution to Advisors\n', '    function sendAdvisorsSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_advisorsSupply);\n', '        balances[to] = balances[to].add(_advisorsSupply);\n', '        Transfer(multisig, to, _advisorsSupply);\n', '    }\n', '    \n', '    // Token distribution to Platform\n', '    function sendPlatformSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_platformSupply);\n', '        balances[to] = balances[to].add(_platformSupply);\n', '        Transfer(multisig, to, _platformSupply);\n', '    }\n', '    \n', '    // Token distribution to Bounty\n', '    function sendBountySupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_bountySupply);\n', '        balances[to] = balances[to].add(_bountySupply);\n', '        Transfer(multisig, to, _bountySupply);\n', '    }\n', '    \n', '    // Start or pause tradable to Transfer token\n', '    function startTradable(bool _tradable) public onlyOwner {\n', '        tradable = _tradable;\n', '    }\n', '\n', '    // @return total tokens supplied\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // @return total tokens supplied\n', '    function presaleTotalNumberTokenSold() public view returns (uint256) {\n', '        return presaleTotalNumberTokenSold;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public canTradable returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public canTradable returns (bool success)  {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0\n', '        );\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '    \n', '    // Get current price of a Token\n', '    // @return the price or token value for a ether\n', '    function getPrice() public view returns (uint256 result) {\n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days) && (presaleTotalNumberTokenSold < _saleSupply)) {\n', '            \n', '\t\t\tif ((now > preSaleStartTime) && (now < preSaleStartTime + 14 days)) {\n', '                return 15000;\n', '            } else if ((now >= preSaleStartTime + 14 days) && (now < preSaleStartTime + 28 days)) {\n', '                return 13000;\n', '            } else if ((now >= preSaleStartTime + 28 days) && (now < preSaleStartTime + 42 days)) {\n', '                return 11000;\n', '            } else if ((now >= preSaleStartTime + 42 days)) {\n', '                return 10500;\n', '            }\n', '\t\t\t\n', '        } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days) && (mainsaleTotalNumberTokenSold < _mainsaleSupply)) {\n', '            if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '                return 10000;\n', '            }\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(owner==msg.sender);\n', '    _;\n', ' }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      owner = newOwner;\n', '  }\n', '}\n', '  \n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BetleyToken is Ownable, ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Token properties\n', '    string public name = "BetleyToken";               //Token name\n', '    string public symbol = "BETS";                     //Token symbol\n', '    uint256 public decimals = 18;\n', '\n', '    uint256 public _totalSupply = 1000000000e18;       //100% Total Supply\n', '\t\n', '    uint256 public _mainsaleSupply = 350000000e18;     //35% Main Sale\n', '    uint256 public _presaleSupply = 650000000e18;      //65% Pre Sale\n', '\t\n', '    uint256 public _saleSupply = 390000000e18;         //60% Sale\n', '    uint256 public _teamSupply = 65000000e18;          //10% Team\n', '    uint256 public _advisorsSupply = 55250000e18;      //8.5% Advisors\n', '    uint256 public _platformSupply = 130000000e18;     //20% Platform\n', '    uint256 public _bountySupply = 9750000e18;         //1.5% Bounty\n', '\n', '    // Address of owners who will get distribution tokens\n', '    address private _teamAddress = 0x5cFDe81cF1ACa91Ff8b7fEa63cFBF81B713BBf00;\n', '    address private _advisorsAddress = 0xC9F2DE0826235767c95254E1887e607d9Af7aA81;\n', '    address private _platformAddress = 0x572eE1910DD287FCbB109320098B7EcC33CB7e51;\n', '    address private _bountyAddress = 0xb496FB1F0660CccA92D1B4B199eDcC4Eb8992bfA;\n', '    uint256 public isDistributionTransferred = 0;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '    \n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public preSaleStartTime; \n', '    uint256 public mainSaleStartTime;\n', '\n', '    // Wallet Address of Token\n', '    address public multisig;\n', '\n', '    // Wallet Adddress of Secured User\n', '    address public sec_addr;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public price;\n', '\n', '    uint256 public minContribAmount = 0.1 ether;\n', '    uint256 public maxContribAmount = 100 ether;\n', '\n', '    uint256 public hardCap = 30000 ether;\n', '    uint256 public softCap = 1200 ether;\n', '    \n', '    //number of total tokens sold \n', '    uint256 public presaleTotalNumberTokenSold=0;\n', '    uint256 public mainsaleTotalNumberTokenSold=0;\n', '\n', '    bool public tradable = false;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    modifier canTradable() {\n', '        require(tradable || ((now < mainSaleStartTime + 30 days) && (now > preSaleStartTime)));\n', '        _;\n', '    }\n', '\n', '    // Constructor\n', '    // @notice BetleyToken Contract\n', '    // @return the transaction address\n', '    function BetleyToken() public{\n', '        // Initial Owner Wallet Address\n', '        multisig = 0x7BAD2a7C2c2E83f0a6E9Afbd3cC0029391F3B013;\n', '\n', '        balances[multisig] = _totalSupply;\n', '\n', '        preSaleStartTime = 1527811200; // June 1st 10:00 AEST\n', '        mainSaleStartTime = 1533081600; // August 1st 10:00 AEST\n', '\n', '        owner = msg.sender;\n', '\n', '        sendTeamSupplyToken(_teamAddress);\n', '        sendAdvisorsSupplyToken(_advisorsAddress);\n', '        sendPlatformSupplyToken(_platformAddress);\n', '        sendBountySupplyToken(_bountyAddress);\n', '        isDistributionTransferred = 1;\n', '    }\n', '\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () external payable {\n', '        tokensale(msg.sender);\n', '    }\n', '\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        require(recipient != 0x0);\n', '        require(msg.value >= minContribAmount && msg.value <= maxContribAmount);\n', '        price = getPrice();\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokenToSend = weiAmount.mul(price);\n', '        \n', '        require(tokenToSend > 0);\n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {\n', '\t\t\n', '\t\t\trequire(_presaleSupply >= tokenToSend);\n', '\t\t\n', '        } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '            \t\n', '            require(_mainsaleSupply >= tokenToSend);\n', '        \n', '\t\t}\n', '        \n', '        balances[multisig] = balances[multisig].sub(tokenToSend);\n', '        balances[recipient] = balances[recipient].add(tokenToSend);\n', '        \n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days)) {\n', '            \n', '\t\t\tpresaleTotalNumberTokenSold = presaleTotalNumberTokenSold.add(tokenToSend);\n', '            _presaleSupply = _presaleSupply.sub(tokenToSend);\n', '        \n', '\t\t} else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '            \n', '\t\t\tmainsaleTotalNumberTokenSold = mainsaleTotalNumberTokenSold.add(tokenToSend);\n', '            _mainsaleSupply = _mainsaleSupply.sub(tokenToSend);\n', '        \n', '\t\t}\n', '\n', '        address tar_addr = multisig;\n', '        if (presaleTotalNumberTokenSold + mainsaleTotalNumberTokenSold > 10000000) { // Transfers ETHER to wallet after softcap is hit\n', '            tar_addr = sec_addr;\n', '        }\n', '        tar_addr.transfer(msg.value);\n', '        TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);\n', '    }\n', '\n', '    // Security Wallet address setting\n', '    function setSecurityWalletAddr(address addr) public onlyOwner {\n', '        sec_addr = addr;\n', '    }\n', '\n', '    // Token distribution to Team\n', '    function sendTeamSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_teamSupply);\n', '        balances[to] = balances[to].add(_teamSupply);\n', '        Transfer(multisig, to, _teamSupply);\n', '    }\n', '\n', '    // Token distribution to Advisors\n', '    function sendAdvisorsSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_advisorsSupply);\n', '        balances[to] = balances[to].add(_advisorsSupply);\n', '        Transfer(multisig, to, _advisorsSupply);\n', '    }\n', '    \n', '    // Token distribution to Platform\n', '    function sendPlatformSupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_platformSupply);\n', '        balances[to] = balances[to].add(_platformSupply);\n', '        Transfer(multisig, to, _platformSupply);\n', '    }\n', '    \n', '    // Token distribution to Bounty\n', '    function sendBountySupplyToken(address to) public onlyOwner {\n', '        require ((to != 0x0) && (isDistributionTransferred == 0));\n', '\n', '        balances[multisig] = balances[multisig].sub(_bountySupply);\n', '        balances[to] = balances[to].add(_bountySupply);\n', '        Transfer(multisig, to, _bountySupply);\n', '    }\n', '    \n', '    // Start or pause tradable to Transfer token\n', '    function startTradable(bool _tradable) public onlyOwner {\n', '        tradable = _tradable;\n', '    }\n', '\n', '    // @return total tokens supplied\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // @return total tokens supplied\n', '    function presaleTotalNumberTokenSold() public view returns (uint256) {\n', '        return presaleTotalNumberTokenSold;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public canTradable returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public canTradable returns (bool success)  {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0\n', '        );\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '    \n', '    // Get current price of a Token\n', '    // @return the price or token value for a ether\n', '    function getPrice() public view returns (uint256 result) {\n', '        if ((now > preSaleStartTime) && (now < preSaleStartTime + 60 days) && (presaleTotalNumberTokenSold < _saleSupply)) {\n', '            \n', '\t\t\tif ((now > preSaleStartTime) && (now < preSaleStartTime + 14 days)) {\n', '                return 15000;\n', '            } else if ((now >= preSaleStartTime + 14 days) && (now < preSaleStartTime + 28 days)) {\n', '                return 13000;\n', '            } else if ((now >= preSaleStartTime + 28 days) && (now < preSaleStartTime + 42 days)) {\n', '                return 11000;\n', '            } else if ((now >= preSaleStartTime + 42 days)) {\n', '                return 10500;\n', '            }\n', '\t\t\t\n', '        } else if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days) && (mainsaleTotalNumberTokenSold < _mainsaleSupply)) {\n', '            if ((now > mainSaleStartTime) && (now < mainSaleStartTime + 30 days)) {\n', '                return 10000;\n', '            }\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '}']