['pragma solidity 0.5.1;\n', '\n', '\n', ' contract simpleToken {\n', '     address public beneficiary;\n', "     string public standard = 'https://mshk.top';\n", '     string public name;    \n', '     string public symbol;  \n', '     uint8 public decimals = 8;  \n', '     uint256 public totalSupply = 10000000000000; \n', '     /* This creates an array with all balances */\n', '     mapping (address => uint256) public balanceOf;\n', '\n', '     event Transfer(address indexed from, address indexed to, uint256 value);  \n', '\n', '  \n', '     constructor(string memory tokenName, string memory  tokenSymbol) public {\n', '         name = tokenName;\n', '         symbol = tokenSymbol;\n', '        \n', '         beneficiary = msg.sender;\n', '         balanceOf[msg.sender] = totalSupply;\n', '         emit Transfer(msg.sender, msg.sender, totalSupply);\n', '     }\n', '\n', '     modifier onlyOwner() { require(msg.sender == beneficiary); _; }\n', '\n', '     function transfer(address _to, uint256 _value) public{\n', '       require(balanceOf[msg.sender] >= _value);\n', '      \n', '       balanceOf[msg.sender] -= _value;\n', '\n', '     \n', '       balanceOf[_to] += _value;\n', '\n', '      \n', '       emit Transfer(msg.sender, _to, _value);\n', '     }\n', '\n', '     function issue(address _to, uint256 _amount) public onlyOwner(){\n', '         require(balanceOf[beneficiary] >= _amount);\n', '        \n', '         balanceOf[beneficiary] -= _amount;\n', '         balanceOf[_to] += _amount;\n', '        \n', '         emit Transfer(beneficiary, _to, _amount);\n', '     }\n', '  }\n', '\n', '\n', 'contract Crowdsale is simpleToken {\n', '    uint public amountRaised; \n', '    uint public price;  \n', '    uint256 public counterForTokenId = 0;\n', '    mapping(address => uint256) public balanceInEthAtCrowdsale; \n', ' \n', '    event FundTransfer(address _backer, uint _amount, bool _isContribution);    \n', '\n', '    event SetPrice(address _beneficiary, uint _price);\n', '    \n', '    event AddSupplyAmount(string msg, uint _amount);\n', '  \n', '    constructor(\n', '        string memory tokenName,\n', '        string memory tokenSymbol\n', '    ) public simpleToken(tokenName, tokenSymbol){\n', '        price = 2 finney; //1?以太?可以? 500 ?代?\n', '    }\n', ' \n', '    function internalIssue(address _to, uint256 _amount) private{\n', '     require(balanceOf[beneficiary] >= _amount);\n', '    \n', '     balanceOf[beneficiary] -= _amount;\n', '     balanceOf[_to] += _amount;\n', '   \n', '     emit Transfer(beneficiary, _to, _amount);\n', '    }\n', '  \n', '    function () external payable {\n', '\n', '        uint amount = msg.value;\n', '     \n', '        balanceInEthAtCrowdsale[msg.sender] += amount;\n', '        \n', '        amountRaised += amount;\n', '\n', '        internalIssue(msg.sender, amount / price * 10 ** uint256(decimals));\n', '        emit FundTransfer(msg.sender, amount, true);\n', '       \n', '        counterForTokenId = counterForTokenId + 1;\n', '        \n', '    }\n', '\n', '   \n', '    function safeWithdrawal() public onlyOwner(){\n', '       \n', '        msg.sender.transfer(amountRaised);\n', '\n', '        emit FundTransfer(msg.sender, amountRaised, false);\n', '        amountRaised = 0;\n', '    }\n', '    \n', '    function setPrice (uint price_in_finney) public onlyOwner(){\n', '        price = price_in_finney * 1 finney;\n', '        emit SetPrice(msg.sender, price);\n', '    }\n', '    \n', '    function addSupplyAmount (uint256 amount) public onlyOwner(){\n', '        totalSupply = totalSupply + amount; \n', '        balanceOf[msg.sender] += amount;\n', '\n', '       \n', '        emit Transfer(msg.sender, msg.sender , amount);\n', "        emit AddSupplyAmount('Add Supply Amount', amount);\n", '    }\n', '}']