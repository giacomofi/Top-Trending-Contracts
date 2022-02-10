['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '\n', 'import "./SafeERC20.sol";\n', 'import "./IERC721Receiver.sol";\n', 'import "./ERC721.sol";\n', '\n', '/**\n', ' * @dev A token holder contract that will allow a beneficiary to extract the\n', ' * tokens after a given release time. \n', ' * \n', ' * NOTE THIS ONE WORKS WITH UNI V3 TOKENS!!!! SPECIFICALLY FOR EPSTEIN TOKEN!!!\n', ' *\n', ' * Useful for simple vesting schedules like "advisors get all of their tokens\n', ' * after 1 year".\n', ' */\n', 'contract TokenTimelock is IERC721Receiver{\n', '    using SafeERC20 for IERC20;\n', '\n', '    // ERC721 basic token contract being held\n', '    IERC721 immutable private _token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address immutable private _beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 immutable private _releaseTime;\n', '\n', '    constructor (IERC721 token_, address beneficiary_, uint256 releaseTime_) {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(releaseTime_ > block.timestamp, "TokenTimelock: release time is before current time");\n', '        _token = token_;\n', '        _beneficiary = beneficiary_;\n', '        _releaseTime = releaseTime_;\n', '    }\n', '    \n', '    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {\n', '        return this.onERC721Received.selector;\n', '    }\n', '\n', '    /**\n', '     * @return the token being held.\n', '     */\n', '    function token() public view virtual returns (IERC721) {\n', '        return _token;\n', '    }\n', '\n', '    /**\n', '     * @return the beneficiary of the tokens.\n', '     */\n', '    function beneficiary() public view virtual returns (address) {\n', '        return _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @return the time when the tokens are released.\n', '     */\n', '    function releaseTime() public view virtual returns (uint256) {\n', '        return _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public virtual {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");\n', '\n', '        uint256 amount = token().balanceOf(address(this));\n', '        require(amount > 0, "TokenTimelock: no tokens to release");\n', '\n', '        token().safeTransferFrom(address(this), beneficiary(), 20234);\n', '        \n', '    }\n', '}']