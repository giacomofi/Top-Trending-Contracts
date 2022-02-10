['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-12\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = _a * _b;\n', '        assert(c / _a == _b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        return _a / _b;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        assert(_b <= _a);\n', '        return _a - _b;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '        c = _a + _b;\n', '        assert(c >= _a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal balances;\n', '\n', '    //mapping(address => uint256) internal backBala;\n', '    mapping(address => uint256) internal outBala;\n', '    mapping(address => uint256) internal inBala;\n', '    mapping(address => bool) internal isLockAddress;\n', '    mapping(address => bool) internal isLockAddressMoreSix;\n', '    mapping(address => uint256) internal startLockTime;\n', '    mapping(address => uint256) internal releaseScale;\n', '\n', '    uint256 internal totalSupply_ = 2100000000e18;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        //require(isLockAddress[msg.sender], "fsdfdsfdfdsfcccccccc");\n', '\n', '        if(isLockAddress[msg.sender]){\n', '            if(isLockAddressMoreSix[msg.sender]){\n', '                require(now >= (startLockTime[msg.sender] + 180 days));\n', '            }\n', '            uint256 nRelease = getCurrentBalance(msg.sender);\n', '            require(_value <= nRelease);\n', '            outBala[msg.sender] = outBala[msg.sender].add(_value);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        if(isLockAddress[_to]){\n', '            inBala[_to] = inBala[_to].add(_value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getCurrentBalance(address _owner) public view returns (uint256) {\n', '        uint256 curRelease = now.sub(startLockTime[_owner]).div(1 weeks).mul(releaseScale[_owner]);\n', '        curRelease = curRelease.add(inBala[_owner]);\n', '        return curRelease.sub(outBala[_owner]);\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function setAddressInitValue(address _to, uint256 _value, uint256 _scal, bool _bsixmore) internal {\n', '        balances[_to] = balances[_to].add(_value);\n', '        //backBala[_to] = balances[_to];\n', '        isLockAddress[_to] = true;\n', '        isLockAddressMoreSix[_to] = _bsixmore;\n', '        startLockTime[_to] = now;\n', '        releaseScale[_to] = _scal;\n', '        emit Transfer(address(0), _to, _value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        if(isLockAddress[_from]){\n', '            if(isLockAddressMoreSix[_from]){\n', '                require(now >= (startLockTime[_from] + 180 days));\n', '            }\n', '\n', '            uint256 nRelease = getCurrentBalance(_from);\n', '            require(_value <= nRelease);\n', '            outBala[_from] = outBala[_from].add(_value);\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        if(isLockAddress[_to]){\n', '            inBala[_to] = inBala[_to].add(_value);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){\n', '        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier hasMintPermission() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool){\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() public onlyOwner canMint returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool){\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success){\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success){\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '    address public pendingOwner;\n', '\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    function claimOwnership() public onlyPendingOwner {\n', '        emit OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic _token, address _to, uint256 _value) internal {\n', '        require(_token.transfer(_to, _value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {\n', '        require(_token.transferFrom(_from, _to, _value));\n', '    }\n', '\n', '    function safeApprove(ERC20 _token, address _spender, uint256 _value) internal {\n', '        require(_token.approve(_spender, _value));\n', '    }\n', '}\n', '\n', 'contract CanReclaimToken is Ownable {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    function reclaimToken(ERC20Basic _token) external onlyOwner {\n', '        uint256 balance = _token.balanceOf(address(this));\n', '        _token.safeTransfer(owner, balance);\n', '    }\n', '}\n', '\n', '//Aom token\n', 'contract AOM is StandardToken, MintableToken, PausableToken, CanReclaimToken, Claimable {\n', '\n', '    string public name = "A lot of money";\n', '    string public symbol = "AOM";\n', '    uint8 public decimals = 18;\n', '\n', '    constructor() public {\n', '        setAddressInitValue(0x8D3d68C945309c37cF2229a76015CBEE616CCB53, 84042000e18, 491322e18, false);\n', '        setAddressInitValue(0x396811e07211e4A241fC7F04023A3Bc1ad0F4Ba6, 62790000e18, 367080e18, false);\n', '        setAddressInitValue(0x65FB99A819EF06949F6E910Fe70FE3cA28181F3b, 42021000e18, 245661e18, false);\n', '        setAddressInitValue(0x6d5d7781D320f2550C70bE1f9F93e2590201f1f0, 21010500e18, 122830e18, false);\n', '        setAddressInitValue(0x385A42aA7426ff5FE3649a2e843De6A5920F5825, 15818250e18, 92476e18, false);\n', '        setAddressInitValue(0x43bF99849fDFc48CD0152Cf79DaBB05795606fF9, 15818250e18, 92476e18, false);\n', '\n', '        setAddressInitValue(0xF6B8A480196363Bde2395851c7764D6B5B361963, 199500000e18, 404115e18, false);\n', '\n', '        setAddressInitValue(0x8338f947274F5eD84D69D49Ab03FB949225B63f0, 125832000e18, 1035694e18, true);\n', '        setAddressInitValue(0x4bc3D53f8DFd969293DF00B97b2beF3C70D46471, 84084000e18, 692076e18, true);\n', '        setAddressInitValue(0x2f5DA0660dD59e3Afc1292201C2d1c4e403b5Cad, 84084000e18, 692076e18, true);\n', '\n', '        balances[0x0fa82DDD35E88E6d154aa0a31fB30E2B1ca0D161] = 21000000e18;\n', '        emit Transfer(address(0), 0x0fa82DDD35E88E6d154aa0a31fB30E2B1ca0D161, 21000000e18);\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(1344000000e18);\n', '        emit Transfer(address(0), msg.sender, 1344000000e18);\n', '    }\n', '\n', '    function setReleaseScale(address _adr, uint256 _scaleValue) public onlyOwner returns (bool) {\n', '        releaseScale[_adr] = _scaleValue;\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() public onlyOwner returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        revert("renouncing ownership is blocked");\n', '    }\n', '}']