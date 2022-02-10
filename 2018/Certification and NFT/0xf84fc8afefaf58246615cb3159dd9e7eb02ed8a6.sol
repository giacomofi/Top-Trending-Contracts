['pragma solidity ^0.4.18;\n', '\n', 'contract ERC223Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transfer(address to, uint256 value, bytes data) public returns (bool);\n', '    function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC223 is ERC223Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract IOwned {\n', '    function owner() public pure returns (address) { owner; }\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', 'contract Owned is IOwned {\n', '    \n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract LecStop is Owned{\n', '\n', '    bool public stopped = false;\n', '\n', '    modifier stoppable {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '    function stop() public ownerOnly{\n', '        stopped = true;\n', '    }\n', '    function start() public ownerOnly{\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract LecBatchTransfer is  Owned,LecStop{\n', '    \n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '    \n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '    \n', '    event LOG_Transfer_Contract(address indexed _from, uint256 _value, bytes indexed _data);\n', '\n', '    function LecBatchTransfer() public{\n', '    }\n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public{\n', '        LOG_Transfer_Contract(_from, _value, _data);\n', '    }\n', '    \n', '    function batchTransfer(ERC223 _token,address[] _to,uint256 _amountOfEach) public \n', '    ownerOnly stoppable validAddress(_token){\n', '        require(_to.length > 0 && _amountOfEach > 0 && _to.length * _amountOfEach <=  _token.balanceOf(this) && _to.length < 10000);\n', '        for(uint16 i = 0; i < _to.length ;i++){\n', '          assert(_token.transfer(_to[i],_amountOfEach));\n', '        }\n', '    }\n', '    \n', '    function withdrawTo(address _to, uint256 _amount)\n', '        public ownerOnly stoppable\n', '        notThis(_to)\n', '    {   \n', '        require(_amount <= this.balance);\n', '        _to.transfer(_amount); // send the amount to the target account\n', '    }\n', '    \n', '    function withdrawERC20TokenTo(ERC223 _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract ERC223Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transfer(address to, uint256 value, bytes data) public returns (bool);\n', '    function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC223 is ERC223Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract IOwned {\n', '    function owner() public pure returns (address) { owner; }\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', 'contract Owned is IOwned {\n', '    \n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract LecStop is Owned{\n', '\n', '    bool public stopped = false;\n', '\n', '    modifier stoppable {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '    function stop() public ownerOnly{\n', '        stopped = true;\n', '    }\n', '    function start() public ownerOnly{\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract LecBatchTransfer is  Owned,LecStop{\n', '    \n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '    \n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '    \n', '    event LOG_Transfer_Contract(address indexed _from, uint256 _value, bytes indexed _data);\n', '\n', '    function LecBatchTransfer() public{\n', '    }\n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public{\n', '        LOG_Transfer_Contract(_from, _value, _data);\n', '    }\n', '    \n', '    function batchTransfer(ERC223 _token,address[] _to,uint256 _amountOfEach) public \n', '    ownerOnly stoppable validAddress(_token){\n', '        require(_to.length > 0 && _amountOfEach > 0 && _to.length * _amountOfEach <=  _token.balanceOf(this) && _to.length < 10000);\n', '        for(uint16 i = 0; i < _to.length ;i++){\n', '          assert(_token.transfer(_to[i],_amountOfEach));\n', '        }\n', '    }\n', '    \n', '    function withdrawTo(address _to, uint256 _amount)\n', '        public ownerOnly stoppable\n', '        notThis(_to)\n', '    {   \n', '        require(_amount <= this.balance);\n', '        _to.transfer(_amount); // send the amount to the target account\n', '    }\n', '    \n', '    function withdrawERC20TokenTo(ERC223 _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '\n', '    }\n', '\n', '}']