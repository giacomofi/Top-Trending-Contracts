['pragma solidity ^0.4.25;\n', '\n', '/*** @title SafeMath\n', ' * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface ERC20 {\n', '    function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);\n', '    function mintFromICO(address _to, uint256 _amount) external  returns(bool);\n', '    function isWhitelisted(address wlCandidate) external returns(bool);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title CrowdSale\n', ' * @dev https://github.com/\n', ' */\n', 'contract PreICO is Ownable {\n', '\n', '    ERC20 public token;\n', '    \n', '    ERC20 public authorize;\n', '    \n', '    using SafeMath for uint;\n', '\n', '    address public backEndOperator = msg.sender;\n', '    address bounty = 0xAddEB4E7780DB11b7C5a0b7E96c133e50f05740E; // 0.4% - для баунти программы\n', '\n', '    mapping(address=>bool) public whitelist;\n', '\n', '    mapping(address => uint256) public investedEther;\n', '\n', '    uint256 public startPreICO = 1543700145; \n', '    uint256 public endPreICO = 1547510400; \n', '\n', '    uint256 public investors; // total number of investors\n', '    uint256 public weisRaised; // total amount collected by ether\n', '\n', '    uint256 public hardCap1Stage = 10000000*1e18; // 10,000,000 SPC = $1,000,000 EURO\n', '\n', '    uint256 public buyPrice; // 0.1 EURO\n', '    uint256 public euroPrice; // Ether by USD\n', '\n', '    uint256 public soldTokens; // solded tokens - > 10,000,000 SPC\n', '\n', '    event Authorized(address wlCandidate, uint timestamp);\n', '    event Revoked(address wlCandidate, uint timestamp);\n', '    event UpdateDollar(uint256 time, uint256 _rate);\n', '\n', '    modifier backEnd() {\n', '        require(msg.sender == backEndOperator || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // contract constructor\n', '    constructor(ERC20 _token, ERC20 _authorize, uint256 usdETH) public {\n', '        token = _token;\n', '        authorize = _authorize;\n', '        euroPrice = usdETH;\n', '        buyPrice = (1e18/euroPrice).div(10); // 0.1 euro\n', '    }\n', '\n', '    // change the date of commencement of pre-sale\n', '    function setStartSale(uint256 newStartSale) public onlyOwner {\n', '        startPreICO = newStartSale;\n', '    }\n', '\n', '    // change the date of the end of pre-sale\n', '    function setEndSale(uint256 newEndSale) public onlyOwner {\n', '        endPreICO = newEndSale;\n', '    }\n', '\n', '    // Change of operator’s backend address\n', '    function setBackEndAddress(address newBackEndOperator) public onlyOwner {\n', '        backEndOperator = newBackEndOperator;\n', '    }\n', '\n', '    // Change in the rate of dollars to broadcast\n', '    function setBuyPrice(uint256 _dollar) public backEnd {\n', '        euroPrice = _dollar;\n', '        buyPrice = (1e18/euroPrice).div(10); // 0.1 euro\n', '        emit UpdateDollar(now, euroPrice);\n', '    }\n', '\n', '\n', '    /*******************************************************************************\n', "     * Payable's section\n", '     */\n', '\n', '    function isPreICO() public constant returns(bool) {\n', '        return now >= startPreICO && now <= endPreICO;\n', '    }\n', '\n', '    // callback contract function\n', '    function () public payable {\n', '        require(authorize.isWhitelisted(msg.sender));\n', '        require(isPreICO());\n', '        require(msg.value >= buyPrice.mul(100)); // ~ 10 EURO\n', '        SalePreICO(msg.sender, msg.value);\n', '        require(soldTokens<=hardCap1Stage);\n', '        investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);\n', '    }\n', '\n', '    // release of tokens during the pre-sale period\n', '    function SalePreICO(address _investor, uint256 _value) internal {\n', '        uint256 tokens = _value.mul(1e18).div(buyPrice);\n', '        token.mintFromICO(_investor, tokens);\n', '        soldTokens = soldTokens.add(tokens);\n', '        uint256 tokensBoynty = tokens.div(250); // 2 %\n', '        token.mintFromICO(bounty, tokensBoynty);\n', '        weisRaised = weisRaised.add(_value);\n', '    }\n', '    \n', '    function manualMint(address _investor, uint256 _tokens)  public onlyOwner {\n', '        token.mintFromICO(_investor, _tokens);\n', '    }\n', '    \n', '    // Sending air from the contract\n', '    function transferEthFromContract(address _to, uint256 amount) public onlyOwner {\n', '        _to.transfer(amount);\n', '    }\n', '\n', '   \n', '}']