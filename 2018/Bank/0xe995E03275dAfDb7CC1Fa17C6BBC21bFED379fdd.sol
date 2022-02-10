['pragma solidity ^0.4.18;\n', '\n', 'contract TokenInterface{\n', '    uint256 public totalSupply;\n', '    uint256 public price;\n', '    uint256 public decimals;\n', '    function () public payable;\n', '    function balanceOf(address _owner) view public returns(uint256);\n', '    function transfer(address _to, uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract SWAP{\n', '    \n', '    string public name="SWAP";\n', '    string public symbol="SWAP";\n', '    \n', '    uint256 public totalSupply; \n', '    uint256 public price = 50;\n', '    uint256 public decimals = 18; \n', '\n', '    address MyETHWallet;\n', '    function SWAP() public {  \n', '        MyETHWallet = msg.sender;\n', '        name="SWAP";\n', '        symbol="SWAP";\n', '    }\n', '\n', '    modifier onlyValidAddress(address _to){\n', '        require(_to != address(0x00));\n', '        _;\n', '    }\n', '    mapping (address => uint256) balances; \n', '    mapping (address => mapping (address => uint256)) public allowance; //phu cap\n', '\n', '    function setPrice(uint256 _price) public returns (uint256){\n', '        price = _price;\n', '        return price;\n', '    }\n', '\n', '    function setDecimals(uint256 _decimals) public returns (uint256){\n', '        decimals = _decimals;\n', '        return decimals;\n', '    }\n', '    \n', '    function balanceOf(address _owner) view public returns(uint256){\n', '        return balances[_owner];\n', '    }\n', '    \n', '    //tạo ra một sự kiện công khai trên blockchain sẽ thông báo cho khách hàng\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Withdraw(address to, uint amount); //rut tien\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        \n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        \n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);  \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '   \n', '    function () public payable {\n', '        uint256 token = (msg.value*price)/10**decimals; //1 eth = 10^18 wei\n', '        totalSupply += token;\n', '        balances[msg.sender] = token;\n', '    }\n', '    \n', '    \n', '    modifier onlyMyETHWallet(){\n', '        require(msg.sender == MyETHWallet);\n', '        _;\n', '    }\n', '    \n', '    function withdrawEtherOnlyOwner() external onlyMyETHWallet{\n', '        msg.sender.transfer(address(this).balance);\n', '        emit Withdraw(msg.sender,address(this).balance);\n', '    }\n', '\n', '    function sendEthToAddress(address _address, uint256 _value) external onlyValidAddress(_address){\n', '        _address.transfer(_value);\n', '        emit Withdraw(_address,_value);\n', '    }\n', '}']