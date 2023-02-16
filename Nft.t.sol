// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Upgradeable.sol";
import "forge-std/console.sol";

contract CounterTest is Test {
    MyNFT impl;
    address alice =  address(0x1337);
    address bob = address(0x1997);
    address nftowner = address(0x69420);

    function setUp() public {
        vm.label(alice,"Alice");
        vm.startPrank(nftowner);
        impl = new MyNFT();
        impl.initializeNft();
        vm.stopPrank();

    }

    function test_owner() public {
        vm.startPrank(nftowner);
        assertEq(impl.owner(),nftowner);
        vm.stopPrank();
    }

    function test_mint() public {
        vm.expectRevert();
        impl.safeMint(alice);
    }

    function test_actualmint() public {
        vm.prank(nftowner);
        impl.safeMint(alice);
        console.log(impl.balanceOf(alice));
        assertTrue(impl.balanceOf(alice) > 0);
    }
}
