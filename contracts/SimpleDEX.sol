// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    using SafeERC20 for IERC20;

    address public tokenA;
    address public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;

    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token address");
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        IERC20(tokenA).safeTransferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).safeTransferFrom(msg.sender, address(this), amountB);
        reserveA += amountA;
        reserveB += amountB;
    }

    function swapAtoB(uint256 amountIn) external {
        require(amountIn > 0, "Amount must be greater than zero");
        uint256 amountOut = (reserveB * amountIn) / (reserveA + amountIn);
        require(amountOut > 0, "Insufficient liquidity");

        IERC20(tokenA).safeTransferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenB).safeTransfer(msg.sender, amountOut);

        reserveA += amountIn;
        reserveB -= amountOut;
    }
}
