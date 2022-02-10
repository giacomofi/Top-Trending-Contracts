['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused;\n', '    \n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    constructor() internal {\n', '        paused = false;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', 'contract BaseToken is Pausable {\n', '    using SafeMath for uint256;\n', '\n', "    string constant public name = 'BiQuanPlus';\n", "    string constant public symbol = 'BQ';\n", '    uint8 constant public decimals = 6;\n', '    uint256 public totalSupply = 2000000000000000;\n', '    uint256 constant public _totalLimit = 100000000000000000000;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address from, address to, uint value) internal {\n', '        require(to != address(0));\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        totalSupply = totalSupply.add(value);\n', '        require(_totalLimit >= totalSupply);\n', '        balanceOf[account] = balanceOf[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnToken is BaseToken {\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function burn(uint256 value) public whenNotPaused returns (bool) {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Burn(msg.sender, value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address from, uint256 value) public whenNotPaused returns (bool) {\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Burn(from, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BatchToken is BaseToken {\n', '    \n', '    function batchTransfer(address[] addressList, uint256[] amountList) public returns (bool) {\n', '        uint256 length = addressList.length;\n', '        require(addressList.length == amountList.length);\n', '        require(length > 0 && length <= 20);\n', '\n', '        for (uint256 i = 0; i < length; i++) {\n', '            transfer(addressList[i], amountList[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract AirdropToken is BaseToken {\n', '    uint256 constant public airMax = 100000000000000;\n', '    uint256 public airTotal = 0;\n', '    uint256 public airBegintime = 1599906993;\n', '    uint256 public airEndtime = 1599906993;\n', '    uint256 public airOnce = 100000000;\n', '    uint256 public airLimitCount = 1;\n', '\n', '    mapping (address => uint256) public airCountOf;\n', '\n', '    event Airdrop(address indexed from, uint256 indexed count, uint256 tokenValue);\n', '    event AirdropSetting(uint256 airBegintime, uint256 airEndtime, uint256 airOnce, uint256 airLimitCount);\n', '\n', '    function airdrop() public payable {\n', '        require(block.timestamp >= airBegintime && block.timestamp <= airEndtime);\n', '        require(msg.value == 0);\n', '        require(airOnce > 0);\n', '        airTotal = airTotal.add(airOnce);\n', '        if (airMax > 0 && airTotal > airMax) {\n', '            revert();\n', '        }\n', '        if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {\n', '            revert();\n', '        }\n', '        _mint(msg.sender, airOnce);\n', '        airCountOf[msg.sender] = airCountOf[msg.sender].add(1);\n', '        emit Airdrop(msg.sender, airCountOf[msg.sender], airOnce);\n', '    }\n', '\n', '    function changeAirdropSetting(uint256 newAirBegintime, uint256 newAirEndtime, uint256 newAirOnce, uint256 newAirLimitCount) public onlyOwner {\n', '        airBegintime = newAirBegintime;\n', '        airEndtime = newAirEndtime;\n', '        airOnce = newAirOnce;\n', '        airLimitCount = newAirLimitCount;\n', '        emit AirdropSetting(newAirBegintime, newAirEndtime, newAirOnce, newAirLimitCount);\n', '    }\n', '\n', '}\n', '\n', 'contract CustomToken is BaseToken, BurnToken, BatchToken, AirdropToken {\n', '    constructor() public {\n', '        balanceOf[0xC5056fD216652F266714Af1b32d1A93c3321C184] = totalSupply;\n', '        emit Transfer(address(0), 0xC5056fD216652F266714Af1b32d1A93c3321C184, totalSupply);\n', '\n', '        owner = 0xC5056fD216652F266714Af1b32d1A93c3321C184;\n', '    }\n', '\n', '    function() public payable {\n', '        airdrop();\n', '    }\n', '}']