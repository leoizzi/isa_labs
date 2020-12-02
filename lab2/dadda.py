from math import floor

import sys
import numpy as np


def gen_ha(dj, i, j, a_row, a_col, b_row, b_col, s_row, s_col, co_row, co_col):
    if co_col <= 63:
        s = "\n\tha_" + str(dj) + "_" + str(i) + "_" + str(j) + ": ha\n" \
                                                        "\t\tport map(\n" \
                                                        "\t\t\ta => dadda_tree_" + str(dj) + "(" + str(a_row) + ")(" + str(a_col) + "),\n" \
                                                        "\t\t\tb => dadda_tree_" + str(dj) + "(" + str(b_row) + ")(" + str(b_col) + "),\n" \
                                                        "\t\t\ts => dadda_tree_" + str(dj-1) + "(" + str(s_row) + ")(" + str(s_col) + "),\n" \
                                                        "\t\t\tco => dadda_tree_" + str(dj-1) + "(" + str(co_row) + ")(" + str(co_col) + ")\n" \
                                                        "\t);\n\n"
    else:
        s = "\n\tha_" + str(dj) + "_" + str(i) + "_" + str(j) + ": ha\n" \
                                                        "\t\tport map(\n" \
                                                        "\t\t\ta => dadda_tree_" + str(dj) + "(" + str(a_row) + ")(" + str(a_col) + "),\n" \
                                                        "\t\t\tb => dadda_tree_" + str(dj) + "(" + str(b_row) + ")(" + str(b_col) + "),\n" \
                                                        "\t\t\ts => dadda_tree_" + str(dj-1) + "(" + str(s_row) + ")(" + str(s_col) + "),\n" \
                                                        "\t\t\tco => open\n" \
                                                        "\t);\n"
    return s


def gen_fa(dj, i, j, a_row, a_col, b_row, b_col, ci_row, ci_col, s_row, s_col, co_row, co_col):
    if co_col <= 63:
        s = "\n\tfa_" + str(dj) + "_" + str(i) + "_" + str(j) + ": fa\n" \
                                                        "\t\tport map(\n" \
                                                        "\t\t\ta => dadda_tree_" + str(dj) + "(" + str(a_row) + ")(" + str(a_col) + "),\n" \
                                                        "\t\t\tb => dadda_tree_" + str(dj) + "(" + str(b_row) + ")(" + str(b_col) + "),\n" \
                                                        "\t\t\tci => dadda_tree_" + str(dj) + "(" + str(ci_row) + ")(" + str(ci_col) + "),\n" \
                                                        "\t\t\ts => dadda_tree_" + str(dj-1) + "(" + str(s_row) + ")(" + str(s_col) + "),\n" \
                                                        "\t\t\tco => dadda_tree_" + str(dj-1) + "(" + str(co_row) + ")(" + str(co_col) + ")\n" \
                                                        "\t);\n"
    else:
        s = "\n\tfa_" + str(dj) + "_" + str(i) + "_" + str(j) + ": fa\n" \
                                                        "\t\tport map(\n" \
                                                        "\t\t\ta => dadda_tree_" + str(dj) + "(" + str(a_row) + ")(" + str(a_col) + "),\n" \
                                                        "\t\t\tb => dadda_tree_" + str(dj) + "(" + str(b_row) + ")(" + str(b_col) + "),\n" \
                                                        "\t\t\tci => dadda_tree_" + str(dj) + "(" + str(ci_row) + ")(" + str(ci_col) + "),\n" \
                                                        "\t\t\ts => dadda_tree_" + str(dj-1) + "(" + str(s_row) + ")(" + str(s_col) + "),\n" \
                                                        "\t\t\tco => open\n" \
                                                        "\t);\n"
    return s


def gen_direct_conn(dj, a_row, a_col, b_row, b_col):
    s = "\tdadda_tree_" + str(dj-1) + "(" + str(a_row) + ")(" + str(a_col) + ") <= dadda_tree_" + str(dj) + "(" + str(b_row) + ")(" + str(b_col) + ");\n"
    return s


def gen_zero_conn(a_row, a_col):
    s = "\tdadda_tree_0(" + str(a_row) + ")(" + str(a_col) + ") <= \'0\';\n"
    return s

# generate the start dot matrix
def gen_start_matrix(n_pp, n_bits):
    pp_matrix = np.zeros((n_pp, 2*n_bits), dtype=int)
    start = 0
    for i in range(0, n_pp):
        if i == 0:  # first row: has 3 dots more
            for j in range(start, n_bits+4):
                pp_matrix[i][j] = 1
            pp_matrix[i+1][start] = 1
        elif i == n_pp-2:  # second to last row: add only one dot
            for j in range(start, 2*n_bits):
                pp_matrix[i][j] = 1
            pp_matrix[i+1][start] = 1
        elif i == n_pp-1:  # last row: add only the pp bits
            for j in range(start, 2*n_bits):
                pp_matrix[i][j] = 1
        else:  # general case
            for j in range(start, start+n_bits+1+2):
                pp_matrix[i][j] = 1
            pp_matrix[i+1][start] = 1

        start = start + 2

    return pp_matrix


# count how many levels are needed and how much dots can exist within a column
def count_levels(n_pp):
    d = 2
    l = 0
    levels = [[l, d]]

    while d < n_pp:
        d = int(floor(3.0/2.0*float(d)))
        l = l+1
        levels.append([l, d])
    return levels


# create the actual matrix used for the instantiation: it has as many rows as the numbers of levels and each column
# stores how many dots are contained in it
def gen_cnt_matrix(levels, n_pp, n_bits, start_matrix):
    cnt_matrix = np.zeros((levels, 2*n_bits), dtype=int)
    for j in range (0, 2*n_bits):
        for i in range(0, n_pp):
            if start_matrix[i][j] == 1:
                cnt_matrix[levels-1][j] = cnt_matrix[levels-1][j] + 1

    return cnt_matrix


# find the index of the first dot in a column of the start matrix
def find_first_dot(start_matrix, col, rows):
    for i in range(0, rows):
        if start_matrix[i][col] == 1:
            return i

    print('find_first_dot was not able to find a dot!')
    sys.exit(1)


# find the index of the last dot in a column of the start matrix
def find_last_dot(start_matrix, col, rows):
    start = find_first_dot(start_matrix, col, rows)
    if start < rows:
        for i in range(start, rows):
            if start_matrix[i][col] == 0:
                return i

    return rows


def print_mat(mat, rows, cols):
    s = ""
    for j in range(0, cols):
        s = s + str(j) + "\t"
    s = s + "\n\n"
    for i in range(0, rows):
        for j in range(0, cols):
            if mat[i][j] == 1:
                s = s + "o\t"
            elif mat[i][j] == 0:
                s = s + "-\t"
            else:
                s = s + "X\t"
        s = s + "\n"

    print(s)



def generate_dadda(n_pp, n_bits):
    pp_matrix = gen_start_matrix(n_pp, n_bits)
    levels = count_levels(n_pp)
    print("[level, max_admitted_bits] = " + str(levels))
    fp = open('instantiation.vhd', 'w')
    mats = []
    lv = levels[-1]
    for l in range(0, lv[0]):
        m = np.zeros((levels[l][1], 2*n_bits), dtype=int)
        mats.append(m)
    mats.append(pp_matrix)

    # lv = levels[-1]
    cnt_matrix = gen_cnt_matrix(lv[0]+1, n_pp, n_bits, pp_matrix)
    # iterate on the levels
    for l in range(lv[0], 0, -1):
        mat_l = mats[l]
        mat_l_1 = mats[l-1]

        print("Matrix level " + str(levels[l][0]))
        if l == lv[0]:
            print_mat(mat_l, n_pp, 2*n_bits)
        else:
            print_mat(mat_l, levels[l][1], 2 * n_bits)

        max_admitted_bits = levels[l-1][1]
        res_inst = 0
        # iterates over all the colums in a given level
        for j in range(0, 2*n_bits):
            bits_in_col = cnt_matrix[l][j]
            bits_in_col_l_1 = cnt_matrix[l-1][j]
            diff = bits_in_col - max_admitted_bits + bits_in_col_l_1
            if diff <= 0:
                # all the bits can go down to the next level
                cnt_matrix[l-1][j] = cnt_matrix[l-1][j] + bits_in_col
                index_l = 0
                index_l_1 = res_inst
                res_inst = 0
                if lv[0] == l:
                    index_l = find_first_dot(pp_matrix, j, n_pp)

                for i in range(index_l, index_l+bits_in_col):
                    s = gen_direct_conn(l, index_l_1, j, i, j)
                    mat_l_1[index_l_1][j] = mat_l_1[index_l_1][j] + 1
                    fp.write(s)
                    index_l_1 = index_l_1+1
            else:
                ha_inst = 0
                fa_inst = 0
                index = 0
                end = 0
                if lv[0] == l:
                    # in the first iteration we may need to find in start_matrix where the dots are actually present
                    index = find_first_dot(pp_matrix, j, n_pp)

                # first, try to instantiate FAs
                s_row = res_inst
                s_col = j
                co_row = 0
                res_inst = 0
                co_col = j+1
                while diff >= 2:
                    fa = gen_fa(l, index, j, index, j, index+1, j, index+2, j, s_row, s_col, co_row, co_col)
                    mat_l_1[s_row][s_col] = mat_l_1[s_row][s_col] + 1
                    if j < 63:
                        mat_l_1[co_row][co_col] = mat_l_1[co_row][co_col] + 1
                    fp.write(fa)
                    diff = diff - 2
                    index = index + 3
                    s_row = s_row + 1
                    co_row = co_row + 1
                    res_inst = res_inst + 1
                    cnt_matrix[l-1][j] = cnt_matrix[l-1][j] + 1
                    if j < 63:
                        cnt_matrix[l-1][j+1] = cnt_matrix[l-1][j+1] + 1
                    fa_inst = fa_inst + 1

                # next, try to instantiate HAs
                while diff >= 1:
                    ha = gen_ha(l, index, j, index, j, index + 1, j, s_row, s_col, co_row, co_col)
                    mat_l_1[s_row][s_col] = mat_l_1[s_row][s_col] + 1
                    if j < 63:
                        mat_l_1[co_row][co_col] = mat_l_1[co_row][co_col] + 1
                    fp.write(ha)
                    diff = diff - 1
                    index = index + 2
                    s_row = s_row + 1
                    co_row = co_row + 1
                    res_inst = res_inst + 1
                    cnt_matrix[l-1][j] = cnt_matrix[l-1][j] + 1
                    if j < 63:
                        cnt_matrix[l-1][j+1] = cnt_matrix[l-1][j+1] + 1
                    ha_inst = ha_inst + 1

                # propagate the remaining bits
                if lv[0] == l:
                    end = find_last_dot(pp_matrix, j, n_pp)
                else:
                    end = cnt_matrix[l][j]
                if index < end:
                    for i in range(index, end):
                        s = gen_direct_conn(l, s_row, j, i, j)
                        mat_l_1[s_row][j] = mat_l_1[s_row][j] + 1
                        fp.write(s)
                        cnt_matrix[l-1][j] = cnt_matrix[l-1][j] + 1
                        s_row = s_row + 1

                print("column " + str(j) + ": FAs = " + str(fa_inst) + ", HAs = " + str(ha_inst))
        print("\n")
    # at the end put any unused signal in dadda_tree_0 to '0'
    mat = mats[0]
    for i in range(0, 2):
        for j in range(0, 2*n_bits):
            if mat[i][j] == 0:
                s = gen_zero_conn(1, j)
                mat[i][j] = mat[i][j] + 1
                fp.write(s)

    print("Final matrix")
    print_mat(mat, 2, 2*n_bits)
    fp.close()


if __name__ == '__main__':
    npp = 17
    nbits = 32
    generate_dadda(npp, nbits)
