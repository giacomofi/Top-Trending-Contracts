['/**\n', ' *\n', ' *            https://ulu.finance\n', ' *\n', ' *       $$\\   $$\\ $$\\      $$\\   $$\\\n', ' *       $$ |  $$ |$$ |     $$ |  $$ |\n', ' *       $$ |  $$ |$$ |     $$ |  $$ |\n', ' *       $$ |  $$ |$$ |     $$ |  $$ |\n', ' *       $$ |  $$ |$$ |     $$ |  $$ |\n', ' *       $$ |  $$ |$$ |     $$ |  $$ |\n', ' *       \\$$$$$$  |$$$$$$$$\\\\$$$$$$  |\n', ' *        \\______/ \\________|\\______/\n', ' *\n', ' *         Universal Liquidity Union\n', ' *\n', ' *            https://ulu.finance\n', ' *\n', ' **/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract ULUReferral {\n', '    mapping(address => address) public referrers; // account_address -> referrer_address\n', '    mapping(address => uint256) public referredCount; // referrer_address -> num_of_referred\n', '\n', '    event Referral(address indexed referrer, address indexed farmer);\n', '\n', '    // Standard contract ownership transfer.\n', '    address public owner;\n', '    address private nextOwner;\n', '\n', '    mapping(address => bool) public isAdmin;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Standard modifier on methods invokable only by contract owner.\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(isAdmin[msg.sender], "OnlyAdmin methods called by non-admin.");\n', '        _;\n', '    }\n', '\n', '    // Standard contract ownership transfer implementation,\n', '    function approveNextOwner(address _nextOwner) external onlyOwner {\n', '        require(_nextOwner != owner, "Cannot approve current owner.");\n', '        nextOwner = _nextOwner;\n', '    }\n', '\n', '    function acceptNextOwner() external {\n', '        require(msg.sender == nextOwner, "Can only accept preapproved new owner.");\n', '        owner = nextOwner;\n', '    }\n', '\n', '    function setReferrer(address farmer, address referrer) public onlyAdmin {\n', '        if (referrers[farmer] == address(0) && referrer != address(0)) {\n', '            referrers[farmer] = referrer;\n', '            referredCount[referrer] += 1;\n', '            emit Referral(referrer, farmer);\n', '        }\n', '    }\n', '\n', '    function getReferrer(address farmer) public view returns (address) {\n', '        return referrers[farmer];\n', '    }\n', '\n', '    // Set admin status.\n', '    function setAdminStatus(address _admin, bool _status) external onlyOwner {\n', '        isAdmin[_admin] = _status;\n', '    }\n', '\n', '    event EmergencyERC20Drain(address token, address owner, uint256 amount);\n', '\n', '    // owner can drain tokens that are sent here by mistake\n', '    function emergencyERC20Drain(ERC20 token, uint amount) external onlyOwner {\n', '        emit EmergencyERC20Drain(address(token), owner, amount);\n', '        token.transfer(owner, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _who) public view returns (uint256);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}']