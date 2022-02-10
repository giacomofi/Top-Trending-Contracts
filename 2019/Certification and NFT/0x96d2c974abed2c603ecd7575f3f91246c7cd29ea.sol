['pragma solidity ^0.5.6;\n', '\n', 'contract owned {\n', '    address payable public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function() external payable  {\n', '    }\n', '    \n', '     function withdraw() onlyOwner public {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', 'interface ERC20 {\n', '  function transfer(address receiver, uint256 value) external returns (bool ok);\n', '}\n', '\n', '\n', 'interface ERC223Receiver {\n', '    function tokenFallback(address _from, uint _value, bytes32 _data) external ;\n', '}\n', '\n', '\n', '\n', 'contract SaTT is owned,ERC20 {\n', '\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant totalSupply = 20000000000000000000000000000; // 20 billions and 18 decimals\n', '    string public constant symbol = "SATT";\n', '    string public constant name = "Smart Advertising Transaction Token";\n', '    \n', '\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '    \n', '   \n', '    constructor () public {\n', '        balanceOf[msg.sender] = totalSupply;               \n', '    }\n', '    \n', '     function isContract(address _addr) internal view returns (bool is_contract) {\n', '      bytes32 hash;\n', '     \n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            hash := extcodehash(_addr)\n', '      }\n', '      return (hash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);\n', '    }\n', '    \n', '     function transfer(address to, uint256 value) public returns (bool success) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '     function transfer(address to, uint256 value,bytes memory  data) public returns (bool success) {\n', '         if((data[0])!= 0) { \n', '            _transfer(msg.sender, to, value);\n', '         }\n', '        return true;\n', '    }\n', '    \n', '     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        \n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '       \n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != address(0x0));\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        \n', '        if(isContract(_to))\n', '        {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, bytes32(0));\n', '        }\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '     function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferToken (address token,address to,uint256 val) public onlyOwner {\n', '        ERC20 erc20 = ERC20(token);\n', '        erc20.transfer(to,val);\n', '    }\n', '    \n', '     function tokenFallback(address _from, uint _value, bytes memory  _data) pure public {\n', '       \n', '    }\n', '\n', '}']