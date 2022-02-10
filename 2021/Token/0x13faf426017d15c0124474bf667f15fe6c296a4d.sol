['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-16\n', '*/\n', '\n', 'pragma solidity =0.5.17;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public;\n', '    function approve(address spender, uint256 value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract SignRecover {\n', '    function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32)\n', '    {\n', '        require(sig.length == 65);\n', '\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        assembly {\n', '        // first 32 bytes, after the length prefix\n', '            r := mload(add(sig, 32))\n', '        // second 32 bytes\n', '            s := mload(add(sig, 64))\n', '        // final byte (first byte of the next 32 bytes)\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        return (v, r, s);\n', '    }\n', '\n', '    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address)\n', '    {\n', '        uint8 v;\n', '        bytes32 r;\n', '        bytes32 s;\n', '\n', '        (v, r, s) = splitSignature(sig);\n', '\n', '        return ecrecover(message, v, r, s);\n', '    }\n', '}\n', 'contract GalaxyPay is Ownable, SignRecover {\n', '    using SafeMath for uint;\n', '    event GovWithdraw(address indexed to,uint256 value);\n', '\n', '    address public signer;\n', '    mapping (address => mapping (address => uint)) public tokenRecords;\n', '    mapping (address => uint) public ethRecords;\n', '\n', '    mapping (address => bool) public isBlackListed;\n', '    function addBlackList (address _evilUser) public onlyOwner {\n', '        isBlackListed[_evilUser] = true;\n', '    }\n', '    function removeBlackList (address _clearedUser) public onlyOwner {\n', '        isBlackListed[_clearedUser] = false;\n', '    }\n', '\n', '    function setSigner(address _addr) public onlyOwner {\n', '        require(_addr != address(0));\n', '        signer = _addr;\n', '    }\n', '\n', '    function sendToken(address _token,  uint256  _balance, bytes memory _sig) public {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(signer != address(0), "no signer");\n', '        string memory func = "sendToken";\n', '        bytes32 message = keccak256(abi.encodePacked(this, func, msg.sender, _token,_balance));\n', '        require(recoverSigner(message, _sig) == signer,"sign err");\n', '        ERC20 erc20token = ERC20(_token);\n', '        address _to = msg.sender;\n', '        uint send = _balance.sub(tokenRecords[_token][msg.sender]);\n', '        tokenRecords[_token][msg.sender] = _balance;\n', '        erc20token.transfer(_to, send);\n', '    }\n', '\n', '    function sendEth(uint256  _balance, bytes memory _sig) public {\n', '        require(!isBlackListed[msg.sender]);\n', '        require(signer != address(0), "no signer");\n', '        string memory func = "sendEth";\n', '        bytes32 message = keccak256(abi.encodePacked(this, func, msg.sender, _balance));\n', '        require(recoverSigner(message, _sig) == signer,"sign err");\n', '        uint send = _balance.sub(ethRecords[msg.sender]);\n', '        ethRecords[msg.sender] = _balance;\n', '        msg.sender.transfer(send);\n', '    }\n', '\n', '    function() external payable {\n', '    }\n', '\n', '    function govWithdraw(uint256 _amount)onlyOwner public {\n', '        require(_amount > 0,"!zero input");\n', '        msg.sender.transfer(_amount);\n', '        emit GovWithdraw(msg.sender,_amount);\n', '    }\n', '\n', '    function govWithdrawToken(address _token, uint256 _amount)onlyOwner public {\n', '        require(_amount > 0,"!zero input");\n', '        ERC20 erc20token = ERC20(_token);\n', '        address _to = msg.sender;\n', '        erc20token.transfer(_to, _amount);\n', '    }\n', '}']