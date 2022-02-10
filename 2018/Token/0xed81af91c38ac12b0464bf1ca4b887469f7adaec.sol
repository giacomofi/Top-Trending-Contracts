['pragma solidity ^0.4.18;\n', '\n', '\n', ' /*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        //   require(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        //   require(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ControlCentreInterface\n', ' * @dev ControlCentreInterface is an interface for providing commonly used function\n', ' * signatures to the ControlCentre\n', ' */\n', 'contract ControllerInterface {\n', '\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256);\n', '    function approve(address owner, address spender, uint256 value) public returns (bool);\n', '    function transfer(address owner, address to, uint value, bytes data) public returns (bool);\n', '    function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '}\n', '\n', '\n', '/*\n', ' * ERC20Basic\n', ' * Simpler version of ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', 'contract ERC223Basic is ERC20Basic {\n', '    function transfer(address to, uint value, bytes data) public returns (bool);\n', '}\n', '\n', 'contract ERC20 is ERC223Basic {\n', '    // active supply of tokens\n', '    function allowance(address _owner, address _spender) public constant returns (uint256);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Token is Ownable, ERC20 {\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintToggle(bool status);\n', '\n', '    // Constant Functions\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return ControllerInterface(owner).balanceOf(_owner);\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return ControllerInterface(owner).totalSupply();\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return ControllerInterface(owner).allowance(_owner, _spender);\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '        bytes memory empty;\n', '        _checkDestination(address(this), _to, _amount, empty);\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function mintToggle(bool status) onlyOwner public returns (bool) {\n', '        MintToggle(status);\n', '        return true;\n', '    }\n', '\n', '    // public functions\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        ControllerInterface(owner).approve(msg.sender, _spender, _value);\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transfer(_to, _value, empty);\n', '    }\n', '\n', '    function transfer(address to, uint value, bytes data) public returns (bool) {\n', '        ControllerInterface(owner).transfer(msg.sender, to, value, data);\n', '        Transfer(msg.sender, to, value);\n', '        _checkDestination(msg.sender, to, value, data);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transferFrom(_from, _to, _value, empty);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {\n', '        ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);\n', '        Transfer(_from, _to, _amount);\n', '        _checkDestination(_from, _to, _amount, _data);\n', '        return true;\n', '    }\n', '\n', '    // Internal Functions\n', '    function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {\n', '        uint256 codeLength;\n', '        assembly {\n', '            codeLength := extcodesize(_to)\n', '        }\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);\n', '            // untrusted contract call\n', '            untrustedReceiver.tokenFallback(_from, _value, _data);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DataCentre is Ownable {\n', '    struct Container {\n', '        mapping(bytes32 => uint256) values;\n', '        mapping(bytes32 => address) addresses;\n', '        mapping(bytes32 => bool) switches;\n', '        mapping(address => uint256) balances;\n', '        mapping(address => mapping (address => uint)) constraints;\n', '    }\n', '\n', '    mapping(bytes32 => Container) containers;\n', '\n', '    // Owner Functions\n', '    function setValue(bytes32 _container, bytes32 _key, uint256 _value) public onlyOwner {\n', '        containers[_container].values[_key] = _value;\n', '    }\n', '\n', '    function setAddress(bytes32 _container, bytes32 _key, address _value) public onlyOwner {\n', '        containers[_container].addresses[_key] = _value;\n', '    }\n', '\n', '    function setBool(bytes32 _container, bytes32 _key, bool _value) public onlyOwner {\n', '        containers[_container].switches[_key] = _value;\n', '    }\n', '\n', '    function setBalanace(bytes32 _container, address _key, uint256 _value) public onlyOwner {\n', '        containers[_container].balances[_key] = _value;\n', '    }\n', '\n', '\n', '    function setConstraint(bytes32 _container, address _source, address _key, uint256 _value) public onlyOwner {\n', '        containers[_container].constraints[_source][_key] = _value;\n', '    }\n', '\n', '    // Constant Functions\n', '    function getValue(bytes32 _container, bytes32 _key) public constant returns(uint256) {\n', '        return containers[_container].values[_key];\n', '    }\n', '\n', '    function getAddress(bytes32 _container, bytes32 _key) public constant returns(address) {\n', '        return containers[_container].addresses[_key];\n', '    }\n', '\n', '    function getBool(bytes32 _container, bytes32 _key) public constant returns(bool) {\n', '        return containers[_container].switches[_key];\n', '    }\n', '\n', '    function getBalanace(bytes32 _container, address _key) public constant returns(uint256) {\n', '        return containers[_container].balances[_key];\n', '    }\n', '\n', '    function getConstraint(bytes32 _container, address _source, address _key) public constant returns(uint256) {\n', '        return containers[_container].constraints[_source][_key];\n', '    }\n', '}\n', '\n', 'contract Governable {\n', '\n', '    // list of admins, council at first spot\n', '    address[] public admins;\n', '\n', '    modifier onlyAdmins() {\n', '        var(adminStatus, ) = isAdmin(msg.sender);\n', '        require(adminStatus == true);\n', '        _;\n', '    }\n', '\n', '    function Governable() public {\n', '        admins.length = 1;\n', '        admins[0] = msg.sender;\n', '    }\n', '\n', '    function addAdmin(address _admin) public onlyAdmins {\n', '        var(adminStatus, ) = isAdmin(_admin);\n', '        require(!adminStatus);\n', '        require(admins.length < 10);\n', '        admins[admins.length++] = _admin;\n', '    }\n', '\n', '    function removeAdmin(address _admin) public onlyAdmins {\n', '        var(adminStatus, pos) = isAdmin(_admin);\n', '        require(adminStatus);\n', '        require(pos < admins.length);\n', '        // if not last element, switch with last\n', '        if (pos < admins.length - 1) {\n', '            admins[pos] = admins[admins.length - 1];\n', '        }\n', '        // then cut off the tail\n', '        admins.length--;\n', '    }\n', '\n', '    function isAdmin(address _addr) internal returns (bool isAdmin, uint256 pos) {\n', '        isAdmin = false;\n', '        for (uint256 i = 0; i < admins.length; i++) {\n', '            if (_addr == admins[i]) {\n', '            isAdmin = true;\n', '            pos = i;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Governable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = true;\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused(address _to) {\n', '        var(adminStatus, ) = isAdmin(_to);\n', '        require(!paused || adminStatus);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused(address _to) {\n', '        var(adminStatus, ) = isAdmin(_to);\n', '        require(paused || adminStatus);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() onlyAdmins whenNotPaused(msg.sender) public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() onlyAdmins whenPaused(msg.sender) public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract DataManager is Pausable {\n', '\n', '    // satelite contract addresses\n', '    address public dataCentreAddr;\n', '\n', '    function DataManager(address _dataCentreAddr) {\n', '        dataCentreAddr = _dataCentreAddr;\n', '    }\n', '\n', '    // Constant Functions\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return DataCentre(dataCentreAddr).getBalanace("FORCE", _owner);\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return DataCentre(dataCentreAddr).getValue("FORCE", "totalSupply");\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return DataCentre(dataCentreAddr).getConstraint("FORCE", _owner, _spender);\n', '    }\n', '\n', '    function _setTotalSupply(uint256 _newTotalSupply) internal {\n', '        DataCentre(dataCentreAddr).setValue("FORCE", "totalSupply", _newTotalSupply);\n', '    }\n', '\n', '    function _setBalanceOf(address _owner, uint256 _newValue) internal {\n', '        DataCentre(dataCentreAddr).setBalanace("FORCE", _owner, _newValue);\n', '    }\n', '\n', '    function _setAllowance(address _owner, address _spender, uint256 _newValue) internal {\n', '        require(balanceOf(_owner) >= _newValue);\n', '        DataCentre(dataCentreAddr).setConstraint("FORCE", _owner, _spender, _newValue);\n', '    }\n', '\n', '}\n', '\n', 'contract SimpleControl is DataManager {\n', '    using SafeMath for uint;\n', '\n', '    // not necessary to store in data centre  address public satellite;\n', '\n', '    address public satellite;\n', '\n', '    modifier onlyToken {\n', '        require(msg.sender == satellite);\n', '        _;\n', '    }\n', '\n', '    function SimpleControl(address _satellite, address _dataCentreAddr) public\n', '        DataManager(_dataCentreAddr)\n', '    {\n', '        satellite = _satellite;\n', '    }\n', '\n', '    // public functions\n', '    function approve(address _owner, address _spender, uint256 _value) public onlyToken whenNotPaused(_owner) {\n', '        require(_owner != _spender);\n', '        _setAllowance(_owner, _spender, _value);\n', '    }\n', '\n', '    function transfer(address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused(_from) {\n', '        _transfer(_from, _to, _amount, _data);\n', '    }\n', '\n', '    function transferFrom(address _sender, address _from, address _to, uint256 _amount, bytes _data) public onlyToken whenNotPaused(_sender) {\n', '        _setAllowance(_from, _to, allowance(_from, _to).sub(_amount));\n', '        _transfer(_from, _to, _amount, _data);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal {\n', '        require(_to != address(this));\n', '        require(_to != address(0));\n', '        require(_amount > 0);\n', '        require(_from != _to);\n', '        _setBalanceOf(_from, balanceOf(_from).sub(_amount));\n', '        _setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '    }\n', '}\n', '\n', '\n', 'contract CrowdsaleControl is SimpleControl {\n', '    using SafeMath for uint;\n', '\n', '    // not necessary to store in data centre\n', '    bool public mintingFinished;\n', '\n', '    modifier canMint(bool status, address _to) {\n', '        var(adminStatus, ) = isAdmin(_to);\n', '        require(!mintingFinished == status || adminStatus);\n', '        _;\n', '    }\n', '\n', '    function CrowdsaleControl(address _satellite, address _dataCentreAddr) public\n', '        SimpleControl(_satellite, _dataCentreAddr)\n', '    {\n', '\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) whenNotPaused(_to) canMint(true, msg.sender) onlyAdmins public returns (bool) {\n', '        _setTotalSupply(totalSupply().add(_amount));\n', '        _setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '        Token(satellite).mint(_to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function startMinting() onlyAdmins public returns (bool) {\n', '        mintingFinished = false;\n', '        Token(satellite).mintToggle(mintingFinished);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyAdmins public returns (bool) {\n', '        mintingFinished = true;\n', '        Token(satellite).mintToggle(mintingFinished);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' Simple Token based on OpenZeppelin token contract\n', ' */\n', 'contract Controller is CrowdsaleControl {\n', '\n', '    /**\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '    */\n', '    function Controller(address _satellite, address _dataCentreAddr) public\n', '        CrowdsaleControl(_satellite, _dataCentreAddr)\n', '    {\n', '\n', '    }\n', '\n', '    // Owner Functions\n', '    function setContracts(address _satellite, address _dataCentreAddr) public onlyAdmins whenPaused(msg.sender) {\n', '        dataCentreAddr = _dataCentreAddr;\n', '        satellite = _satellite;\n', '    }\n', '\n', '    function kill(address _newController) public onlyAdmins whenPaused(msg.sender) {\n', '        if (dataCentreAddr != address(0)) { \n', '            Ownable(dataCentreAddr).transferOwnership(msg.sender);\n', '        }\n', '        if (satellite != address(0)) {\n', '            Ownable(satellite).transferOwnership(msg.sender);\n', '        }\n', '        selfdestruct(_newController);\n', '    }\n', '}']