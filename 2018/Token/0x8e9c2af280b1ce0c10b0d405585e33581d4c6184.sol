['pragma solidity ^0.4.25;\n', '\n', 'contract Token {\n', '    string  public name;\n', '    string  public symbol;\n', '    //string  public standard = "Token v1.0";\n', '    uint256 public totalSupply;\n', '    //\n', '    address public minter;\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    constructor (uint256 _initialSupply, string memory _name, string memory _symbol, address _minter) public {\n', '        balanceOf[_minter] = _initialSupply;\n', '        totalSupply = _initialSupply;\n', '        name = _name;\n', '        symbol =_symbol;\n', '        //\n', '        minter =_minter;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function getTokenDetails() public view returns(address _minter, string memory _name, string memory _symbol, uint256 _totalsupply) {\n', '        return(minter, name, symbol, totalSupply);\n', '    }\n', '}\n', '\n', 'contract tokenSale {\n', '    address admin;\n', '    Token public tokenContract;\n', '    uint256 public tokenPrice;\n', '    uint256 public tokensSold;\n', '    string public phasename;\n', '\n', '    event Sell(address _buyer, uint256 _amount);\n', '\n', '    constructor (Token _tokenContract, uint256 _tokenPrice, string memory _phasename, address _admin) public {\n', '        admin = _admin;\n', '        tokenContract = _tokenContract;\n', '        tokenPrice = _tokenPrice;\n', '        phasename = _phasename;\n', '    }\n', '\n', '    function multiply(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '    // buying tokens from wallet other than metamask, which requires token recipient address\n', '    function rbuyTokens(address recipient_addr, uint256 _numberOfTokens) public payable {\n', '        require(msg.sender==admin);\n', '        require(msg.value == multiply(_numberOfTokens, tokenPrice));\n', '        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens);\n', '        require(tokenContract.transfer(recipient_addr, _numberOfTokens));\n', '\n', '        tokensSold += _numberOfTokens;\n', '\n', '        emit Sell(msg.sender, _numberOfTokens);\n', '    }\n', '\n', '    function approveone(address spender, uint256 value) public {\n', '        require(msg.sender==admin);\n', '        tokenContract.approve(spender, value);\n', '    }\n', '\n', '    function buyTokens(uint256 _numberOfTokens) public payable {\n', '        require(msg.value == multiply(_numberOfTokens, tokenPrice));\n', '        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens); //----!!!!!!!\n', '        require(tokenContract.transfer(msg.sender, _numberOfTokens));\n', '\n', '        tokensSold += _numberOfTokens;\n', '\n', '        emit Sell(msg.sender, _numberOfTokens);\n', '    }\n', '\n', '    function getmoney() public {\n', '        require(msg.sender==admin);\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '\n', '    function endSale() public {\n', '        require(msg.sender == admin);\n', '        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));\n', '\n', "        // UPDATE: Let's not destroy the contract here\n", '        // Just transfer the balance to the admin\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '}']