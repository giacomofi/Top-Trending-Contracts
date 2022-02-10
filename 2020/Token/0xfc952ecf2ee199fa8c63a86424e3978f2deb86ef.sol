['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-21\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Series is Ownable {\n', '  string name;\n', '  mapping(address=>address[]) plugins;\n', '\n', '  constructor(string memory _name) public {\n', '    name = _name;\n', '  }\n', '\n', '  function getName() public view returns (string memory) {\n', '    return name;\n', '  }\n', '}\n', '\n', 'contract OtoCorp is Ownable {\n', '    \n', '    uint256 private tknSeriesFee;\n', '    IERC20 private tkn;\n', '    uint private seriesIndex = 1;\n', '    mapping(address=>address[]) seriesOfMembers;\n', '    \n', '    event TokenAddrChanged(address _oldTknAddr, address _newTknAddr);\n', '    event ReceiveTokenFrom(address src, uint256 val);\n', '    event NewSeriesCreated(address _contract, address _owner, string _name);\n', '    event SeriesFeeChanged(uint256 _oldFee, uint256 _newFee);\n', '    event TokenWithdrawn(address _owner, uint256 _total);\n', '    \n', '    constructor(IERC20 _tkn) public {\n', '        tkn = _tkn;\n', '        tknSeriesFee = 0**18;\n', '    }\n', '    \n', '    function withdrawTkn() external onlyOwner {\n', '        require(tkn.transfer(owner(), balanceTkn()));\n', '        emit TokenWithdrawn(owner(), balanceTkn());\n', '    }\n', '    \n', '    function createSeries(string memory seriesName) public payable {\n', '        require(tkn.transferFrom(msg.sender, address(this), tknSeriesFee));\n', '        emit ReceiveTokenFrom(msg.sender, tknSeriesFee);\n', "        seriesName = string(abi.encodePacked(seriesName, ' - Series ', getIndex()));\n", '        Series newContract = new Series(seriesName);\n', '        seriesIndex ++;\n', '        seriesOfMembers[msg.sender].push(address(newContract));\n', '        newContract.transferOwnership(msg.sender);\n', '        emit NewSeriesCreated(address(newContract), newContract.owner(), newContract.getName());\n', '    }\n', '    \n', '    function changeTknAddr(IERC20 newTkn) external onlyOwner {\n', '        address oldTknAddr = address(tkn);\n', '        tkn = newTkn;\n', '        emit TokenAddrChanged(oldTknAddr, address(tkn));\n', '    }\n', '    \n', '    function changeSeriesFee(uint256 _newFee) external onlyOwner {\n', '        uint256 oldFee = tknSeriesFee;\n', '        tknSeriesFee = _newFee;\n', '        emit SeriesFeeChanged(oldFee, tknSeriesFee);\n', '    }\n', '    \n', '    function balanceTkn() public view returns (uint256){\n', '        return tkn.balanceOf(address(this));\n', '    }\n', '    \n', '    function isUnlockTkn() public view returns (bool){\n', '        return tkn.allowance(msg.sender, address(this)) > 0;\n', '    }\n', '    \n', '    function mySeries() public view returns (address[] memory) {\n', '        return seriesOfMembers[msg.sender];\n', '    }\n', '    \n', '    function getIndex() public view returns (string memory) {\n', '        return uint2str(seriesIndex);\n', '    }\n', '    \n', '    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {\n', '        if (_i == 0) {\n', '            return "0";\n', '        }\n', '        uint j = _i;\n', '        uint len;\n', '        while (j != 0) {\n', '            len++;\n', '            j /= 10;\n', '        }\n', '        bytes memory bstr = new bytes(len);\n', '        uint k = len - 1;\n', '        while (_i != 0) {\n', '            bstr[k--] = byte(uint8(48 + _i % 10));\n', '            _i /= 10;\n', '        }\n', '        return string(bstr);\n', '    }\n', '}']