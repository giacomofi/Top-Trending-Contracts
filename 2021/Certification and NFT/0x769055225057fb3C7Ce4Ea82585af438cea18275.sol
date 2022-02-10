['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-23\n', '*/\n', '\n', '// File: contracts\\farming\\FarmData.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'struct FarmingPositionRequest {\n', '    uint256 setupIndex; // index of the chosen setup.\n', '    uint256 amount0; // amount of main token or liquidity pool token.\n', '    uint256 amount1; // amount of other token or liquidity pool token. Needed for gen2\n', '    address positionOwner; // position extension or address(0) [msg.sender].\n', '}\n', '\n', 'struct FarmingSetupConfiguration {\n', "    bool add; // true if we're adding a new setup, false we're updating it.\n", '    bool disable;\n', "    uint256 index; // index of the setup we're updating.\n", '    FarmingSetupInfo info; // data of the new or updated setup\n', '}\n', '\n', 'struct FarmingSetupInfo {\n', '    uint256 blockDuration; // duration of setup\n', '    uint256 startBlock; // optional start block used for the delayed activation of the first setup\n', '    uint256 originalRewardPerBlock;\n', '    uint256 minStakeable; // minimum amount of staking tokens.\n', "    uint256 renewTimes; // if the setup is renewable or if it's one time.\n", '    address liquidityPoolTokenAddress; // address of the liquidity pool token\n', '    address mainTokenAddress; // eg. buidl address.\n', '    bool involvingETH; // if the setup involves ETH or not.\n', '    uint256 setupsCount; // number of setups created by this info.\n', '    uint256 lastSetupIndex; // index of last setup;\n', '    int24 tickLower; // Gen2 Only - tickLower of the UniswapV3 pool\n', '    int24 tickUpper; // Gen 2 Only - tickUpper of the UniswapV3 pool\n', '}\n', '\n', 'struct FarmingSetup {\n', '    uint256 infoIndex; // setup info\n', '    bool active; // if the setup is active or not.\n', '    uint256 startBlock; // farming setup start block.\n', '    uint256 endBlock; // farming setup end block.\n', '    uint256 lastUpdateBlock; // number of the block where an update was triggered.\n', '    uint256 objectId; // need for gen2. uniswapV3 NFT position Id\n', '    uint256 rewardPerBlock; // farming setup reward per single block.\n', '    uint128 totalSupply; // Total LP token liquidity of all the positions of this setup\n', '}\n', '\n', 'struct FarmingPosition {\n', '    address uniqueOwner; // address representing the owner of the position.\n', '    uint256 setupIndex; // the setup index related to this position.\n', '    uint256 creationBlock; // block when this position was created.\n', '    uint128 liquidityPoolTokenAmount; // amount of liquidity pool token in the position.\n', '    uint256 reward; // position reward.\n', '}\n', '\n', '// File: contracts\\farming\\IFarmExtension.sol\n', '\n', '//SPDX_License_Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', 'pragma abicoder v2;\n', '\n', '\n', 'interface IFarmExtension {\n', '\n', '    function init(bool byMint, address host, address treasury) external;\n', '\n', '    function setHost(address host) external;\n', '    function setTreasury(address treasury) external;\n', '\n', '    function data() external view returns(address farmMainContract, bool byMint, address host, address treasury, address rewardTokenAddress);\n', '\n', '    function transferTo(uint256 amount) external;\n', '    function backToYou(uint256 amount) external payable;\n', '\n', '    function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;\n', '}\n', '\n', '// File: contracts\\farming\\IFarmMain.sol\n', '\n', '//SPDX_License_Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '//pragma abicoder v2;\n', '\n', '\n', 'interface IFarmMain {\n', '\n', '    function ONE_HUNDRED() external view returns(uint256);\n', '    function _rewardTokenAddress() external view returns(address);\n', '    function position(uint256 positionId) external view returns (FarmingPosition memory);\n', '    function setups() external view returns (FarmingSetup[] memory);\n', '    function setup(uint256 setupIndex) external view returns (FarmingSetup memory, FarmingSetupInfo memory);\n', '    function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;\n', '    function openPosition(FarmingPositionRequest calldata request) external payable returns(uint256 positionId);\n', '    function addLiquidity(uint256 positionId, FarmingPositionRequest calldata request) external payable;\n', '}\n', '\n', '// File: contracts\\farming\\util\\IERC20.sol\n', '\n', '// SPDX_License_Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function safeApprove(address spender, uint256 amount) external;\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', '// File: contracts\\farming\\util\\IERC20Mintable.sol\n', '\n', '// SPDX_License_Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IERC20Mintable {\n', '    function mint(address wallet, uint256 amount) external returns (bool);\n', '    function burn(address wallet, uint256 amount) external returns (bool);\n', '}\n', '\n', '// File: contracts\\farming\\FarmExtension.sol\n', '\n', '//SPDX_License_Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '//pragma abicoder v2;\n', '\n', '\n', '\n', '\n', '\n', 'contract FarmExtension is IFarmExtension {\n', '\n', '    // wallet who has control on the extension and treasury\n', '    address internal _host;\n', '    address internal _treasury;\n', '    // address of the farm main contract linked to this extension\n', '    address internal _farmMainContract;\n', '    // the reward token address linked to this extension\n', '    address internal _rewardTokenAddress;\n', '    // whether the token is by mint or by reserve\n', '    bool internal _byMint;\n', '\n', '    /** MODIFIERS */\n', '\n', '    /** @dev farmMainOnly modifier used to check for unauthorized transfers. */\n', '    modifier farmMainOnly() {\n', '        require(msg.sender == _farmMainContract, "Unauthorized");\n', '        _;\n', '    }\n', '\n', '    /** @dev hostOnly modifier used to check for unauthorized edits. */\n', '    modifier hostOnly() {\n', '        require(msg.sender == _host, "Unauthorized");\n', '        _;\n', '    }\n', '\n', '    /** PUBLIC METHODS */\n', '\n', '    receive() external payable {\n', '        require(_farmMainContract != address(0) && _rewardTokenAddress == address(0), "ETH not allowed");\n', '    }\n', '\n', '    function init(bool byMint, address host, address treasury) public virtual override {\n', '        require(_farmMainContract == address(0), "Already init");\n', '        require((_host = host) != address(0), "blank host");\n', '        _rewardTokenAddress = IFarmMain(_farmMainContract = msg.sender)._rewardTokenAddress();\n', '        _byMint = byMint;\n', '        _treasury = treasury != address(0) ? treasury : host;\n', '    }\n', '\n', '    function data() view public virtual override returns(address farmMainContract, bool byMint, address host, address treasury, address rewardTokenAddress) {\n', '        return (_farmMainContract, _byMint, _host, _treasury, _rewardTokenAddress);\n', '    }\n', '\n', '    /** @dev method used to update the extension host.\n', '      * @param host new host address.\n', '     */\n', '    function setHost(address host) public virtual override hostOnly {\n', '        _host = host;\n', '    }\n', '\n', '    /** @dev method used to update the extension treasury.\n', '      * @param treasury new treasury address.\n', '     */\n', '    function setTreasury(address treasury) public virtual override hostOnly {\n', '        _treasury = treasury;\n', '    }\n', '\n', '    /** @dev this function calls the farm main contract with the given address and sets the given farming setups.\n', '      * @param farmingSetups array containing all the farming setups.\n', '     */\n', '    function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) public virtual override hostOnly {\n', '        IFarmMain(_farmMainContract).setFarmingSetups(farmingSetups);\n', '    }\n', '\n', '    /** @dev transfers the input amount to the caller farming contract.\n', '      * @param amount amount of erc20 to transfer or mint.\n', '     */\n', '    function transferTo(uint256 amount) public virtual override farmMainOnly {\n', '        if(_rewardTokenAddress != address(0)) {\n', '            return _byMint ? _mintAndTransfer(_rewardTokenAddress, _farmMainContract, amount) : _safeTransfer(_rewardTokenAddress, _farmMainContract, amount);\n', '        }\n', '        (bool result, ) = _farmMainContract.call{value:amount}("");\n', '        require(result, "ETH transfer failed.");\n', '    }\n', '\n', '    /** @dev transfers the input amount from the caller farming contract to the extension.\n', '      * @param amount amount of erc20 to transfer back or burn.\n', '     */\n', '    function backToYou(uint256 amount) payable public virtual override farmMainOnly {\n', '        if(_rewardTokenAddress != address(0)) {\n', '            _safeTransferFrom(_rewardTokenAddress, msg.sender, _byMint ? address(this) : _treasury, amount);\n', '            if(_byMint) {\n', '                _burn(_rewardTokenAddress, amount);\n', '            }\n', '        } else {\n', '            require(msg.value == amount, "invalid sent amount");\n', '            if(_treasury != address(this)) {\n', '                (bool result, ) = _treasury.call{value:amount}("");\n', '                require(result, "ETH transfer failed.");\n', '            }\n', '        }\n', '    }\n', '\n', '    /** INTERNAL METHODS */\n', '\n', '    function _mintAndTransfer(address erc20TokenAddress, address recipient, uint256 value) internal virtual {\n', '        IERC20Mintable(erc20TokenAddress).mint(recipient, value);\n', '    }\n', '\n', '    function _burn(address erc20TokenAddress, uint256 value) internal virtual {\n', '        IERC20Mintable(erc20TokenAddress).burn(msg.sender, value);\n', '    }\n', '\n', '    /** @dev function used to safely approve ERC20 transfers.\n', '      * @param erc20TokenAddress address of the token to approve.\n', '      * @param to receiver of the approval.\n', '      * @param value amount to approve for.\n', '     */\n', '    function _safeApprove(address erc20TokenAddress, address to, uint256 value) internal virtual {\n', '        bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).approve.selector, to, value));\n', "        require(returnData.length == 0 || abi.decode(returnData, (bool)), 'APPROVE_FAILED');\n", '    }\n', '\n', '    /** @dev function used to safe transfer ERC20 tokens.\n', '      * @param erc20TokenAddress address of the token to transfer.\n', '      * @param to receiver of the tokens.\n', '      * @param value amount of tokens to transfer.\n', '     */\n', '    function _safeTransfer(address erc20TokenAddress, address to, uint256 value) internal virtual {\n', '        bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transfer.selector, to, value));\n', "        require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFER_FAILED');\n", '    }\n', '\n', '    /** @dev this function safely transfers the given ERC20 value from an address to another.\n', '      * @param erc20TokenAddress erc20 token address.\n', '      * @param from address from.\n', '      * @param to address to.\n', '      * @param value amount to transfer.\n', '     */\n', '    function _safeTransferFrom(address erc20TokenAddress, address from, address to, uint256 value) internal virtual {\n', '        bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transferFrom.selector, from, to, value));\n', "        require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFERFROM_FAILED');\n", '    }\n', '\n', '    /** @dev calls the contract at the given location using the given payload and returns the returnData.\n', '      * @param location location to call.\n', '      * @param payload call payload.\n', '      * @return returnData call return data.\n', '     */\n', '    function _call(address location, bytes memory payload) private returns(bytes memory returnData) {\n', '        assembly {\n', '            let result := call(gas(), location, 0, add(payload, 0x20), mload(payload), 0, 0)\n', '            let size := returndatasize()\n', '            returnData := mload(0x40)\n', '            mstore(returnData, size)\n', '            let returnDataPayloadStart := add(returnData, 0x20)\n', '            returndatacopy(returnDataPayloadStart, 0, size)\n', '            mstore(0x40, add(returnDataPayloadStart, size))\n', '            switch result case 0 {revert(returnDataPayloadStart, size)}\n', '        }\n', '    }\n', '}']