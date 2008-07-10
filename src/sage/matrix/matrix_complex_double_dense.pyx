"""
Dense matrices over the Real Double Field.

Matrix operations using numpy.

EXAMPLES:
    sage: b=Mat(RDF,2,3).basis()
    sage: b[0]
    [1.0 0.0 0.0]
    [0.0 0.0 0.0]


We deal with the case of zero rows or zero columns:
    sage: m = MatrixSpace(RDF,0,3)
    sage: m.zero_matrix()
    []

TESTS:
    sage: a = matrix(RDF,2,range(4), sparse=False)
    sage: loads(dumps(a)) == a
    True

AUTHORS:
    -- Jason Grout, Sep 2008: switch to numpy backend
    -- Josh Kantor
    -- William Stein: many bug fixes and touch ups.
"""

##############################################################################
#       Copyright (C) 2004,2005,2006 Joshua Kantor <kantor.jm@gmail.com>
#  Distributed under the terms of the GNU General Public License (GPL)
#  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
##############################################################################
from sage.rings.complex_double import CDF

numpy=None

cdef class Matrix_complex_double_dense(matrix_double_dense.Matrix_double_dense):
    """
    Class that implements matrices over the real double field. These
    are supposed to be fast matrix operations using C doubles. Most
    operations are implemented using numpy which will
    call the underlying BLAS on the system.

    EXAMPLES:
        sage: m = Matrix(RDF, [[1,2],[3,4]])
        sage: m**2
        [ 7.0 10.0]
        [15.0 22.0]
        sage: n= m^(-1); n
        [-2.0  1.0]
        [ 1.5 -0.5]

    To compute eigenvalues the use the functions left_eigenvectors or right_eigenvectors

        sage: p,e = m.right_eigenvectors()

    the result of eigen is a pair (p,e), where p is a list
    of eigenvalues and the e is a matrix whose columns are the eigenvectors.

    To solve a linear system Ax = b
    where A = [[1,2]  and b = [5,6]
             [3,4]]

        sage: b = vector(RDF,[5,6])
        sage: m.solve_left(b)
        (-4.0, 4.5)

    See the commands qr, lu, and svd for QR, LU, and singular value
    decomposition.
    """


    ########################################################################
    # LEVEL 1 functionality
    #   * __new__
    #   * __dealloc__
    #   * __init__
    #   * set_unsafe
    #   * get_unsafe
    #   * __richcmp__    -- always the same
    #   * __hash__       -- alway simple
    ########################################################################
    def __new__(self, parent, entries, copy, coerce):
        global numpy
        if numpy is None:
            import numpy
        self._numpy_dtype = numpy.dtype('complex128')
        self._python_dtype = complex
        self._numpy_dtypeint = NPY_CDOUBLE
        # TODO: Make ComplexDoubleElement instead of CDF for speed
        self._sage_dtype = CDF
        self.__create_matrix__()
        return
